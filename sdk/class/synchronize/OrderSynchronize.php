<?php
/**
* 2014 Affinity-Engine
*
* NOTICE OF LICENSE
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade AffinityItems to newer
* versions in the future. If you wish to customize AffinityItems for your
* needs please refer to http://www.affinity-engine.fr for more information.
*
*  @author    Affinity-Engine SARL <contact@affinity-engine.fr>
*  @copyright 2014 Affinity-Engine SARL
*  @license   http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL Version 2 (GPLv2)
*  International Registered Trademark & Property of Affinity Engine SARL
*/

class OrderSynchronize extends AbstractModuleSynchronize {

	const ORDER = 4;

	public function __construct() { 
		parent::__construct(new OrderRepository());
	}

	public function getCountElementToSynchronize($clause) {
		$countElement = 0;
		if($tmp = AEAdapter::countOrder($clause)) {
			$countElement = (int)$tmp[0]['corder'];
		}
		return $countElement;
	}
	
	public function updateNumberElementSynchronized() { }

	public function syncNewElement() {
		$clause = AEAdapter::newOrderClause();
		$countOrder = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countOrder)) {
			$countPage = ceil($countOrder/parent::BULK_PACKAGE);
			for($cPage = 0; $cPage <= ($countPage - 1); $cPage++) {
				$content = $this->syncOrder($clause);
				$request = new OrderRequest($content);
				if($request->post()) {
					$content = AELibrary::castArray($content);
					$this->getRepository()->insert($content);
				}
			}
		}
	}

	public function syncUpdateElement() {
		$clause = AEAdapter::updateOrderClause();
		$countOrder = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countOrder)) {
			$countPage = ceil($countOrder/parent::BULK_PACKAGE);
			for($cPage = 0; $cPage <= ($countPage - 1); $cPage++) {
				$content = $this->syncOrder($clause);
				$request = new OrderRequest($content);
				if($request->put()) {
					$content = AELibrary::castArray($content);
					$this->getRepository()->update($content);
				}
			}
		}
	}

	public function syncDeleteElement() { /* There is not delete for orders */ }

	public function syncOrder($clause) {
			
		$aeorders = array();

		if (!$orders = AEAdapter::getOrderList($clause, parent::BULK_PACKAGE)) {
			return array();
		}

		foreach ($orders as $order) {

			$orderLines = $this->getOrderLines($order['id_order']);

			$aeorder = new stdClass();
			$aeorder->orderId = $order['id_order'];
			$aeorder->addDate = $order['date_add'];
			$aeorder->updateDate = $order['date_upd'];
			$aeorder->statusId = $order['current_state'];
			$aeorder->statusMessage = $order['statusMessage'];
			$aeorder->paymentMode = $order['payment'];
			$aeorder->language = $order['language'];
			$aeorder->memberId = $order['id_customer'];
			$aeorder->amount = $order['total_paid_tax_excl'];
			$aeorder->currency = $order['currency'];
			$aeorder->orderLines = $orderLines;

			if($guestId = AEAdapter::getCartGuestId($order['id_cart'])) {
				$aeorder->guestId = $guestId;
			}

			if(AEAdapter::isLastSync()) {
				if($group = AEAdapter::getCartGroup($order['id_cart'])) {
						$aeorder->group = $group;
				}
			}
			
			if(!AELibrary::isEmpty(Tools::getRemoteAddr()) && !(bool)Synchronize::getLock())
				$aeorder->ip = Tools::getRemoteAddr();

			array_push($aeorders, $aeorder);
		}

		if(sizeof($aeorders) > 1) {
			return $aeorders;
		} else {
			return $aeorder;
		}
	}

	public function getOrderLines($orderId) {
		$orderLines = array();

		if (!$lines = AEAdapter::getOrderLines($orderId)) {
			return array();
		}

		foreach ($lines as $line) {
			$attributes = array();
			if($line['product_attribute_id'] <> 0) {
				$attr = AEAdapter::getOrdersProductAttributes((int)$line['product_attribute_id']);
				foreach ($attr as $attribute) {
					array_push($attributes, $attribute['id_attribute']);
				}
			}

			$orderLine = new stdClass();
			$orderLine->productId = $line['product_id'];
			$orderLine->attributeIds = $attributes;
			$orderLine->quantity = $line['product_quantity'];
			array_push($orderLines, $orderLine);
		}

		return $orderLines;
	}


}

?>