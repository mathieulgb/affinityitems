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

class ProductAdapter {

	public static function countProduct($clause)
	{
		if (Context::getContext()->shop->isFeatureActive())
		{
			return Db::getInstance()->executeS('SELECT DISTINCT count(*) as cproduct
				FROM `'._DB_PREFIX_.'product_shop` ps
				'.$clause.'
				AND ps.id_shop = '.(int)Shop::getContextShopID(true).';');
		}
		else
		{
			return Db::getInstance()->executeS('SELECT DISTINCT count(*) as cproduct
				FROM `'._DB_PREFIX_.'product` p
				'.$clause.';');
		}
	}

	public static function newProductClause()
	{
		if (Context::getContext()->shop->isFeatureActive())
			return 'WHERE (ps.id_product, ps.id_shop) NOT IN(SELECT id_product, id_shop FROM '._DB_PREFIX_.'ae_product_repository)';
		else
			return 'WHERE p.id_product NOT IN(SELECT id_product FROM '._DB_PREFIX_.'ae_product_repository)';
	}

	public static function updateProductClause()
	{
		if (Context::getContext()->shop->isFeatureActive())
		{
			return 'WHERE ps.date_upd > (SELECT date_upd FROM '._DB_PREFIX_.'ae_product_repository pr WHERE pr.id_product = ps.id_product
				AND id_shop = '.(int)Shop::getContextShopID(true).')';
		}
		else
			return 'WHERE p.date_upd > (SELECT date_upd FROM '._DB_PREFIX_.'ae_product_repository pr WHERE pr.id_product = p.id_product)';
	}

	public static function deleteProductClause()
	{
		if (Context::getContext()->shop->isFeatureActive())
		{
			return Db::getInstance()->ExecuteS('SELECT DISTINCT pr.id_product
				FROM `'._DB_PREFIX_.'ae_product_repository` pr
				WHERE (pr.id_product, pr.id_shop) NOT IN (SELECT ps.id_product, ps.id_shop FROM `'._DB_PREFIX_.'product_shop` ps)
				AND pr.id_shop = '.(int)Shop::getContextShopID(true).';');
		}
		else
		{
			return Db::getInstance()->ExecuteS('SELECT DISTINCT pr.id_product
				FROM `'._DB_PREFIX_.'ae_product_repository` pr
				WHERE pr.id_product NOT IN (SELECT p.id_product FROM `'._DB_PREFIX_.'product` p);');
		}
	}

	public static function getProductList($clause, $bulk)
	{
		if (Context::getContext()->shop->isFeatureActive())
		{
			$available = 'ps.visibility,';
			return Db::getInstance()->executeS('SELECT DISTINCT ps.id_product, ps.date_upd, ps.active, ps.available_for_order, '.$available.' pl.link_rewrite
				FROM `'._DB_PREFIX_.'product_shop` ps
				LEFT JOIN `'._DB_PREFIX_.'product_lang` pl ON pl.id_product = ps.id_product
				'.$clause.'
				AND ps.id_shop = '.(int)Shop::getContextShopID(true).'
				ORDER BY ps.id_product
				LIMIT 0,'.(int)$bulk.';');
		}
		else
		{
			$available = version_compare(_PS_VERSION_, '1.5', '>=') ? 'p.visibility,' : '';
			return Db::getInstance()->executeS('SELECT DISTINCT p.id_product, p.date_upd, p.active, p.available_for_order, '.$available.' pl.link_rewrite
				FROM `'._DB_PREFIX_.'product` p
				LEFT JOIN `'._DB_PREFIX_.'product_lang` pl ON pl.id_product = p.id_product
				'.$clause.'
				ORDER BY p.id_product
				LIMIT 0,'.(int)$bulk.';');
		}
	}

	public static function getProductsLocalizations($product_id)
	{
		$active_lang = !AELibrary::isEmpty(AEAdapter::getActiveLanguageIds()) ? 'AND l.id_lang IN ('.AEAdapter::getActiveLanguageIds().')' : '';
		return Db::getInstance()->executeS('SELECT l.iso_code, pl.description, pl.description_short, pl.name, m.name as mname, s.name as sname
			FROM  `'._DB_PREFIX_.'product` p
			LEFT JOIN `'._DB_PREFIX_.'product_lang` pl ON pl.id_product = p.id_product
			LEFT JOIN `'._DB_PREFIX_.'lang` l ON l.id_lang = pl.id_lang
			LEFT JOIN `'._DB_PREFIX_.'manufacturer` m ON p.id_manufacturer = m.id_manufacturer
			LEFT JOIN `'._DB_PREFIX_.'supplier` s ON p.id_supplier = s.id_supplier
			WHERE p.id_product = '.(int)$product_id.'
			'.$active_lang.';');
	}

	public static function getProductCategories($product_id)
	{
		return Db::getInstance()->ExecuteS('
			SELECT id_category
			FROM '._DB_PREFIX_.'category_product
			WHERE id_product = '.(int)$product_id);
	}

	public static function getProductTags($product_id, $iso_code)
	{
		return Db::getInstance()->ExecuteS('
			SELECT l.`iso_code`, t.`name`
			FROM '._DB_PREFIX_.'tag t
			LEFT JOIN '._DB_PREFIX_.'product_tag pt ON (pt.id_tag = t.id_tag)
			LEFT JOIN '._DB_PREFIX_.'lang l ON (l.id_lang = t.id_lang)
			WHERE l.iso_code = \''.pSQL($iso_code).'\'
			AND pt.`id_product`='.(int)$product_id);
	}

	public static function getProductPrices($product_id)
	{
		return Db::getInstance()->ExecuteS('
			SELECT TRUNCATE(p.price , 2) as price, c.iso_code
			FROM '._DB_PREFIX_.'currency c, '._DB_PREFIX_.'product p
			WHERE p.`id_product`='.(int)$product_id.'
			AND c.id_currency = (SELECT value FROM '._DB_PREFIX_.'configuration WHERE name = \'PS_CURRENCY_DEFAULT\')
			UNION
			SELECT TRUNCATE(p.price , 2) as price, c.iso_code
			FROM '._DB_PREFIX_.'specific_price p, '._DB_PREFIX_.'currency c
			WHERE p.id_currency = c.id_currency
			AND p.`id_product`='.(int)$product_id);
	}

	public static function getProductAttributes($product_id, $iso_code)
	{
		return Db::getInstance()->ExecuteS('
			SELECT DISTINCT al.id_attribute, al.name,  agl.public_name as groupname
			FROM '._DB_PREFIX_.'product_attribute pa, '._DB_PREFIX_.'product_attribute_combination pac, '._DB_PREFIX_.'attribute_lang al
			, '._DB_PREFIX_.'lang l, '._DB_PREFIX_.'attribute a, '._DB_PREFIX_.'attribute_group_lang agl, '._DB_PREFIX_.'attribute_group ag
			WHERE pa.id_product_attribute = pac.id_product_attribute
			AND pac.id_attribute = al.id_attribute
			AND pac.id_attribute = a.id_attribute
			AND al.id_lang = l.id_lang
			AND agl.id_attribute_group = a.id_attribute_group
			AND agl.id_lang = l.id_lang
			AND pa.id_product = '.(int)$product_id.'
			AND l.iso_code = \''.pSQL($iso_code).'\';');

	}

	public static function getProductFeatures($product_id, $iso_code)
	{
		return Db::getInstance()->ExecuteS('
			SELECT DISTINCT fp.id_product, fl.id_feature, fl.name, fvl.id_feature_value, fvl.value
			FROM '._DB_PREFIX_.'feature_lang fl, '._DB_PREFIX_.'lang l, '._DB_PREFIX_.'feature_product fp, '._DB_PREFIX_.'feature_value fv,
			'._DB_PREFIX_.'feature_value_lang fvl
			WHERE fl.id_lang = l.id_lang
			AND fvl.id_lang = l.id_lang
			AND fp.id_feature = fl.id_feature
			AND fp.id_feature_value = fv.id_feature_value
			AND fl.id_feature = fv.id_feature
			AND fv.id_feature_value = fvl.id_feature_value
			AND fp.id_product = '.(int)$product_id.'
			AND l.iso_code=\''.pSQL($iso_code).'\';');
	}

	public static function getProductAttributesByAttributeId($product_id_attribute)
	{
		return Db::getInstance()->ExecuteS('
			SELECT id_attribute
			FROM '._DB_PREFIX_.'product_attribute_combination
			WHERE id_product_attribute = '.(int)$product_id_attribute.';');
	}

	public static function insertProduct($product)
	{
		$multishop = (Context::getContext()->shop->isFeatureActive()) ? Shop::getContextShopID(true) : 1;
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_product_repository` VALUES('.(int)$product->productId.'
			, '.(int)$multishop.' ,\''.pSQL($product->updateDate).'\');');
	}

	public static function updateProduct($product)
	{
		$multishop = (Context::getContext()->shop->isFeatureActive()) ? Shop::getContextShopID(true) : 1;
		Db::getInstance()->execute('UPDATE `'._DB_PREFIX_.'ae_product_repository` SET date_upd = \''.pSQL($product->updateDate).'\'
			WHERE id_product = '.(int)$product->productId.' AND id_shop = '.(int)$multishop.';');
	}

	public static function deleteProduct($product)
	{
		$multishop = (Context::getContext()->shop->isFeatureActive()) ? Shop::getContextShopID(true) : 1;
		Db::getInstance()->execute('DELETE FROM `'._DB_PREFIX_.'ae_product_repository` WHERE id_product = '.(int)$product->productId.'
			AND id_shop = '.(int)$multishop.';');
	}

}

?>