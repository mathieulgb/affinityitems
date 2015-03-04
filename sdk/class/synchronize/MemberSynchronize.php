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
		if($count = MemberAdapter::countMember($clause))
			$countElement = (int)$count[0]['cmember'];
		return $countElement;
	}
	
	public function syncNewElement() {
		$clause = MemberAdapter::newMemberClause();
		$countMember = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countMember)) {
			$countPage = ceil($countMember/parent::BULK_PACKAGE);
			for($page = 0; $page <= ($countPage - 1); $page++) {
				$content = $this->syncMember($clause);
				$request = new MemberRequest($content);
				if($request->post()) 
					$this->getRepository()->insert($content);
			}
		}
	}

	public function syncUpdateElement() {
		$clause = MemberAdapter::updateMemberClause();
		$countMember = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countMember)) {
			$countPage = ceil($countMember/parent::BULK_PACKAGE);
			for($page = 0; $page <= ($countPage - 1); $page++) {
				$content = $this->syncMember($clause);
				$request = new MemberRequest($content);
				if($request->put())
					$this->getRepository()->update($content);
			}
		}
	}

	public function syncDeleteElement() { /* There is not delete for members */ }

	public function syncMember($clause) {
		$aememberList = array();
		$memberList = MemberAdapter::getMemberList($clause, parent::BULK_PACKAGE);

		foreach ($memberList as $member) {
			$aemember = new stdClass();
			$aemember->memberId = $member['id_customer'];
			$aemember->firstname = $member['firstname'];
			$aemember->lastname = $member['lastname'];
			$aemember->email = $member['email'];
			$aemember->birthday = (int)strtotime($member['birthday']);
			$aemember->updateDate = $member['date_upd'];
			array_push($aememberList, $aemember);
		}

		return $aememberList;
	}

}

?>