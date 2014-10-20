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

class MemberSynchronize extends AbstractModuleSynchronize {

	const ORDER = 2;

	public function __construct() { 
		parent::__construct(new MemberRepository());
	}

	public function getCountElementToSynchronize($clause) { 
			$countElement = 0;
			if($tmp = AEAdapter::countMember($clause)) {
				$countElement = (int)$tmp[0]['cmember'];
			}
			return $countElement;
	}
	
	public function updateNumberElementSynchronized() { 

	}

	public function syncNewElement() {
	$clause = AEAdapter::newMemberClause();
		$countMember = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countMember)) {
			$countPage = ceil($countMember/parent::BULK_PACKAGE);
			for($cPage = 0; $cPage <= ($countPage - 1); $cPage++) {
				$content = $this->syncMember($clause);
				$request = new MemberRequest($content);
				if($request->post()) {
					$content = AELibrary::castArray($content);
					$this->getRepository()->insert($content);
				}
			}
		}
	}

	public function syncUpdateElement() {
		$clause = AEAdapter::updateMemberClause();
		$countMember = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countMember)) {
			$countPage = ceil($countMember/parent::BULK_PACKAGE);
			for($cPage = 0; $cPage <= ($countPage - 1); $cPage++) {
				$content = $this->syncMember($clause);
				$request = new MemberRequest($content);
				if($request->put()) {
					$content = AELibrary::castArray($content);
					$this->getRepository()->update($content);
				}
			}
		}
	}

	public function syncDeleteElement() { /* There is not delete for members */ }

	public function syncMember($clause) {

		$aememberList = array();

		$memberList = AEAdapter::getMemberList($clause, parent::BULK_PACKAGE);

		foreach ($memberList as $member) {

			$aemember = new stdClass();
			$aemember->memberId = $member['id_customer'];
			$aemember->firstname = $member['firstname'];
			$aemember->lastname = $member['lastname'];
			$aemember->email = $member['email'];
			$aemember->birthday = (int)strtotime($member['birthday']);
			$aemember->updateDate = $member['date_upd'];

			if(count($memberList) > 1){
				array_push($aememberList, $aemember);
			}
		}
		if(!empty($aememberList)) {
			return $aememberList;
		}
		else {			
			return $aemember;
		}
	}
}

?>