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

class ActionSynchronize extends AbstractModuleSynchronize {

	const ORDER = 4;

	public function __construct() {
		parent::__construct(new ActionRepository());
	}

	public function getCountElementToSynchronize($clause) {
		unset($clause);
		$countElement = 0;
		if($countElement = ActionAdapter::countAction())
			$countElement = (int)$countElement;
		return $countElement;
	}

	public function syncNewElement() {
		$clause = '';
		$countElement = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countElement)) {
			$countPage = ceil($countElement/parent::BULK_PACKAGE);
			for($page = 0; $page <= ($countPage - 1); $page++) {
				$content = $this->syncAction();
				$request = new ActionRequest($content);
				if($request->post())
					$this->getRepository()->delete($content);
			}
		}
	}

	public function syncUpdateElement() { /* There is not update for actions */ }

	public function syncDeleteElement() { /* There is not delete for actions */ }

	public function syncAction() {
		$aeactionList = array();
		if($actionList = ActionAdapter::getActionList(parent::BULK_PACKAGE)) {
			foreach ($actionList as $action) {
				$action = unserialize($action["action"]);
				array_push($aeactionList, $action);
			}
		}
		return $aeactionList;
	}

	public function syncGuestAction($guestId) {
		if($actionList = ActionAdapter::getGuestActionList($guestId)) {
			$content = array();
			foreach ($actionList as $action)
				array_push($content, unserialize($action["action"]));
			$request = new ActionRequest($content);
			if($request->post())
				$this->getRepository()->delete($content);
		}
	}

}

?>