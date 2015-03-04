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

class CategorySynchronize extends AbstractModuleSynchronize {

	const ORDER = 0;

	public function __construct() { 
		parent::__construct(new CategoryRepository());
	}
	
	public function getCountElementToSynchronize($clause) { 
			$countElement = 0;
			if($count = CategoryAdapter::countCategory($clause))
				$countElement = (int)$count[0]['ccategory'];
			return $countElement;
	}

	public function syncNewElement() {
		$clause = CategoryAdapter::newCategoryClause();
		$countCategory = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countCategory)) {
			$countPage = ceil($countCategory/parent::BULK_PACKAGE);
			for($page = 0; $page <= ($countPage - 1); $page++) {
				$content = $this->syncCategory($clause);
				$request = new CategoryRequest($content);
				if($request->post())
					$this->getRepository()->insert($content);
			}
		}
	}

	public function syncUpdateElement() {
		$clause = CategoryAdapter::updateCategoryClause();
		$countCategory = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countCategory)) {
			$countPage = ceil($countCategory/parent::BULK_PACKAGE);
			for($page = 0; $page <= ($countPage - 1); $page++) {
				$content = $this->syncCategory($clause);
				$request = new CategoryRequest($content);
				if($request->put())
					$this->getRepository()->update($content);
			}
		}
	}

	public function syncDeleteElement() {
		$aecategoryList = array();
		$sCategoryList = CategoryAdapter::deleteCategoryClause();
		if(count($sCategoryList) > 0) {
			foreach ($sCategoryList as $categoryId) {
				$category = new stdClass();
				$category->categoryId = $categoryId["id_category"];
				array_push($aecategoryList, $category);
			}
			$request = new CategoryRequest($aecategoryList);
			if($request->delete()) 
				$this->getRepository()->delete($aecategoryList);
		}
	}

	public function syncCategory($clause) {
		$categoryList = array();
		$categories = CategoryAdapter::getCategoryList($clause, parent::BULK_PACKAGE);
		foreach ($categories as $pcategory) {
			$featureList = $this->getFeatureList($pcategory['id_category']);
			$category = new stdClass();
			$category->categoryId = (int)$pcategory['id_category'];
			$category->parentId = (int)$pcategory['id_parent'];
			$category->updateDate = $pcategory['date_upd'];
			$category->localizations = $featureList;
			array_push($categoryList, $category);
		}
		return $categoryList;
	}

	public function getFeatureList($categoryId) {
		$featureList = array();
		$features = CategoryAdapter::getCategoryFeatures($categoryId);
		foreach ($features as $feature)
			array_push($featureList, array("language" => $feature['iso_code'], "name" => $feature['name'], "description" => $feature['description']));
	 	return $featureList;
	}
	
}

?>