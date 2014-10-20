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

class OrderRepository extends AbstractRepository {

	public function __construct() { 
		parent::__construct();
	}

	public function insert($content) {
		try {
			foreach ($content as $order) {
				AEAdapter::insertOrder($order);
			}
		} catch(Exception $e) {
			AELogger::log("[ERROR]", $e->getMessage());
		}
	}

	public function update($content) { 
		try {
			foreach ($content as $order) {
				AEAdapter::updateOrder($order);
			}
		} catch(Exception $e) {
			AELogger::log("[ERROR]", $e->getMessage());
		}
	}

	public function delete($content) {
		unset($content);
	}	

}

?>