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

class OrderAdapter {

	public static function countOrder($clause)
	{
		$multishop = Context::getContext()->shop->isFeatureActive() ? 'AND o.id_shop = '.Shop::getContextShopID(true) : '';
		return Db::getInstance()->executeS('SELECT count(*) as corder
			FROM '._DB_PREFIX_.'orders o
			'.$clause.'
			AND o.id_customer IN (SELECT id_customer FROM '._DB_PREFIX_.'customer)
			AND o.id_order IN (SELECT id_order FROM '._DB_PREFIX_.'order_detail)
			AND id_customer <> 0
			AND o.date_add >= NOW() - INTERVAL \'1\' YEAR
			'.$multishop);
	}

	public static function newOrderClause()
	{
		return 'WHERE o.id_order NOT IN (SELECT id_order FROM '._DB_PREFIX_.'ae_order_repository)';
	}

	public static function updateOrderClause()
	{
		return 'WHERE o.date_upd > (SELECT aeor.date_upd FROM '._DB_PREFIX_.'ae_order_repository aeor WHERE o.id_order = aeor.id_order)';
	}

	public static function getOrderList($clause, $bulk)
	{
		$multishop = Context::getContext()->shop->isFeatureActive() ? 'AND o.id_shop = '.Shop::getContextShopID(true) : '';
		$total_paid = (_PS_VERSION_) >= '1.5' ? 'o.total_paid_tax_excl' : 'o.total_products as total_paid_tax_excl';
		
		if ((_PS_VERSION_) >= '1.5') 
		{
			return Db::getInstance()->ExecuteS('
				SELECT o.id_order, o.date_add, o.date_upd, o.payment, o.current_state, osl.name as statusMessage, c.iso_code as currency, o.id_cart, o.id_customer, 
				'.$total_paid.', l.iso_code as language
				FROM '._DB_PREFIX_.'orders o, '._DB_PREFIX_.'order_state_lang osl, `'._DB_PREFIX_.'lang` l, `'._DB_PREFIX_.'currency` c
				'.$clause.'
				AND o.current_state = osl.id_order_state
				AND o.id_customer IN (SELECT id_customer FROM '._DB_PREFIX_.'customer)
				AND o.id_order IN (SELECT id_order FROM '._DB_PREFIX_.'order_detail)
				AND id_customer <> 0
				AND l.id_lang = o.id_lang
				AND osl.id_lang = o.id_lang
				AND o.id_currency = c.id_currency
				AND o.date_add >= NOW() - INTERVAL \'1\' YEAR
				'.$multishop.'
				LIMIT 0,'.(int)$bulk.';');
		} 
		else 
		{
			return Db::getInstance()->ExecuteS('
				SELECT o.id_order, o.date_add, o.date_upd, o.payment, 
				(SELECT id_order_state FROM `'._DB_PREFIX_.'order_history` oh WHERE oh.`id_order` = o.`id_order` ORDER BY oh.`date_add` DESC LIMIT 1) current_state, 
				osl.name as statusMessage, c.iso_code as currency, o.id_cart, o.id_customer, '.$total_paid.', l.iso_code as language
				FROM '._DB_PREFIX_.'orders o, '._DB_PREFIX_.'order_state_lang osl, `'._DB_PREFIX_.'lang` l, `'._DB_PREFIX_.'currency` c
				'.$clause.'
				AND (SELECT id_order_state FROM `'._DB_PREFIX_.'order_history` oh WHERE oh.`id_order` = o.`id_order` ORDER BY oh.`date_add` DESC LIMIT 1) = osl.id_order_state
				AND o.id_customer IN (SELECT id_customer FROM '._DB_PREFIX_.'customer)
				AND o.id_order IN (SELECT id_order FROM '._DB_PREFIX_.'order_detail)
				AND id_customer <> 0
				AND l.id_lang = o.id_lang
				AND osl.id_lang = o.id_lang
				AND o.id_currency = c.id_currency
				AND o.date_add >= NOW() - INTERVAL \'1\' YEAR
				'.$multishop.'
				LIMIT 0,'.(int)$bulk.';');
		}
	}

	public static function getOrderLines($order_id)
	{
		$amount = ((_PS_VERSION_) >= '1.5') ? 'total_price_tax_excl' : '(product_quantity * product_price)';
		return Db::getInstance()->ExecuteS('SELECT product_id, product_attribute_id, product_quantity, '.$amount.' as amount
			FROM '._DB_PREFIX_.'order_detail
			WHERE id_order = '.(int)$order_id.'
			AND product_id IN (SELECT p.id_product FROM '._DB_PREFIX_.'product p);');
	}

	public static function insertOrder($order)
	{
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_order_repository` VALUES('.(int)$order->orderId.', \''.pSQL($order->addDate).'\'
			, \''.pSQL($order->updateDate).'\');');
	}


	public static function updateOrder($order)
	{
		Db::getInstance()->execute('UPDATE `'._DB_PREFIX_.'ae_order_repository` SET date_upd = \''.pSQL($order->updateDate).'\' 
			WHERE id_order = '.(int)$order->orderId.';');
	}

}

?>