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

class ProductSynchronize extends AbstractModuleSynchronize {

	const ORDER = 1;

	public function __construct() { 
		parent::__construct(new ProductRepository());
	}
	
	public function getCountElementToSynchronize($clause) { 
			$countElement = 0;
			if($count = ProductAdapter::countProduct($clause))
				$countElement = (int)$count[0]['cproduct'];
			return $countElement;
	}

	public function syncNewElement() {
		$clause = ProductAdapter::newProductClause();
		$countProduct = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countProduct)) {
			$countPage = ceil($countProduct/parent::BULK_PACKAGE);
			for($page = 0; $page <= ($countPage - 1); $page++) {
				$content = $this->syncProduct($clause);
				$request = new ProductRequest($content);
				if($request->post())
					$this->getRepository()->insert($content);
			}
		}
	}

	public function syncUpdateElement() {
		$clause = ProductAdapter::updateProductClause();
		$countProduct = $this->getCountElementToSynchronize($clause);
		if(!AELibrary::isNull($countProduct)) {
			$countPage = ceil($countProduct/parent::BULK_PACKAGE);
			for($page = 0; $page <= ($countPage - 1); $page++) {
				$content = $this->syncProduct($clause);
				$request = new ProductRequest($content);
				if($request->put())
					$this->getRepository()->update($content);
			}
		}
	}

	public function syncDeleteElement() {
		$aeproductList = array();
		$productList = ProductAdapter::deleteProductClause();
		if(count($productList) > 0) {
			foreach ($productList as $productId) {
				$product = new stdClass();
				$product->productId = $productId["id_product"];
				array_push($aeproductList, $product);
			}
			$request = new ProductRequest($aeproductList);
			if($request->delete())
				$this->getRepository()->delete($aeproductList);
		}
	}

	public function syncProduct($clause) {
		$aeproductList = array();
		$productList = ProductAdapter::getProductList($clause, parent::BULK_PACKAGE);

		foreach ($productList as $product) {
			$localizationList = array();
			$categoryList = array();
			$priceList = array();

			$localizations = ProductAdapter::getProductsLocalizations((int)$product["id_product"]);

			foreach ($localizations as $localization) {
				$tagList = array();
				$attributeList = array();
				$featureList = array();

				$tagList = $this->getProductTags($product["id_product"], $localization["iso_code"]);
				$attributeList = $this->getProductAttributes($product["id_product"], $localization["iso_code"]);
				$featureList = $this->getProductFeatures($product["id_product"], $localization["iso_code"]);

				$plocalization = new stdClass();
				$plocalization->language = $localization["iso_code"];
				$plocalization->name = $localization["name"];
				$plocalization->shortDescription = $localization["description_short"];
				$plocalization->description = $localization["description"];

				$plocalization->manufacturer = $localization["mname"];
				$plocalization->supplier = $localization["sname"];
				$plocalization->tags = $tagList;
				$plocalization->attributes = $attributeList;
				$plocalization->features = $featureList;

				array_push($localizationList, $plocalization);
			}

			$priceList = $this->getProductPrices($product["id_product"]);
			$categoryList = $this->getCategories($product["id_product"]);

			$aeproduct = new stdClass();
			$aeproduct->productId = (int)$product["id_product"];
			$aeproduct->updateDate = $product["date_upd"];
			$aeproduct->categoryIds = $categoryList;
			$aeproduct->recommendable = $this->isRecommendable($product);			
			$aeproduct->localizations = $localizationList;
			$aeproduct->prices = $priceList;

			array_push($aeproductList, $aeproduct);
		}

		return $aeproductList;
	}

	public function isRecommendable($product) {
		return version_compare(_PS_VERSION_, '1.5', '>=') ? ((bool)$product["active"] && (bool)$product["available_for_order"] && $product["visibility"] != 'none') 
						: ((bool)$product["active"] && (bool)$product["available_for_order"]);
	}
	
	public function getCategories($productId) {
		$categoryList = array();
		if ($categories = ProductAdapter::getProductCategories((int)$productId)) {
			foreach ($categories as $category) {
				array_push($categoryList, (string)$category['id_category']);
			}
		}
		return $categoryList;
	}

	public function getProductTags($productId, $isoCode) {
		$listTag = array();
		if ($tags = ProductAdapter::getProductTags($productId, $isoCode)) {
			foreach ($tags as $tag) {
				array_push($listTag, $tag['name']);
			}
		}
	 	return $listTag;
	}

	public static function getProductPrices($productId) {
	 	$listPrice = array();
	 	$price = new stdClass();
	 	$price->currency = Context::getContext()->currency->iso_code;
	 	$price->amount = Product::getPriceStatic($productId, false);
	 	array_push($listPrice, $price);
	 	if ($prices = ProductAdapter::getProductPrices($productId)) {
	 		foreach ($prices as $pprice) {
	 			if($pprice['iso_code'] != Context::getContext()->currency->iso_code) {
	 				$price = new stdClass();
	 				$price->currency = $pprice['iso_code'];
	 				$price->amount = $pprice['price'];
	 				array_push($listPrice, $price);
	 			}
	 		}
	 	}
	 	return $listPrice;
	 }

	 public static function getProductAttributes($productId, $isoCode){
	 	$listAttribute = array();
	 	$characteristics = array();
	 	if ($attributes = ProductAdapter::getProductAttributes($productId, $isoCode)) {
	 		foreach ($attributes as $attribute)
	 			$characteristics[$attribute['groupname']][] = array("characteristicId" => $attribute['id_attribute'], "name" => $attribute['name']);
	 		foreach ($characteristics as $key => $value) {
	 			$group = new stdClass();
	 			$group->name = $key;
	 			$group->values = $value;
	 			array_push($listAttribute, $group);
	 		}
	 	}
	 	return $listAttribute;
	 }

	public static function getProductFeatures($productId, $isoCode) {
		$listFeature = array();
		$characteristics = array();
		if($features = ProductAdapter::getProductFeatures($productId, $isoCode)) {
			foreach ($features as $feature)
				$characteristics[$feature['name']][] = array("characteristicId" => $feature['id_feature_value'], "name" => $feature['value']);
			foreach ($characteristics as $key => $value) {
				$group = new stdClass();
				$group->name = $key;
				$group->values = $value;
				array_push($listFeature, $group);
			}
		}
	 	return $listFeature;
	}
	
}

?>