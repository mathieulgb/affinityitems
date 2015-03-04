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

class CategoryAdapter {

	public static function countCategory($clause)
	{
		if (Context::getContext()->shop->isFeatureActive())
		{
			return Db::getInstance()->executeS('SELECT DISTINCT count(*) as ccategory
				FROM `'._DB_PREFIX_.'category` c, `'._DB_PREFIX_.'category_shop` cs
				'.$clause.'
				AND c.id_category = cs.id_category
				AND cs.id_shop = '.Shop::getContextShopID(true).';');
		}
		else
		{
			return Db::getInstance()->executeS('SELECT DISTINCT count(*) as ccategory
				FROM `'._DB_PREFIX_.'category` c
				'.$clause.';');
		}
	}

	public static function newCategoryClause()
	{
		if (Context::getContext()->shop->isFeatureActive())
			return 'WHERE (c.id_category, cs.id_shop) NOT IN (SELECT id_category, id_shop FROM '._DB_PREFIX_.'ae_category_repository)';
		else
			return 'WHERE c.id_category NOT IN (SELECT id_category FROM '._DB_PREFIX_.'ae_category_repository)';
	}

	public static function updateCategoryClause()
	{
		if (Context::getContext()->shop->isFeatureActive())
		{
			return 'WHERE c.date_upd > (SELECT cr.date_upd FROM '._DB_PREFIX_.'ae_category_repository cr WHERE c.id_category = cr.id_category
					AND id_shop = '.(int)Shop::getContextShopID(true).')';
		}
		else
			return 'WHERE c.date_upd > (SELECT cr.date_upd FROM '._DB_PREFIX_.'ae_category_repository cr WHERE c.id_category = cr.id_category)';
	}

	public static function deleteCategoryClause()
	{
		if (Context::getContext()->shop->isFeatureActive())
		{
			return Db::getInstance()->ExecuteS('SELECT cr.id_category
				FROM '._DB_PREFIX_.'ae_category_repository cr
				WHERE (cr.id_category, cr.id_shop) NOT IN (SELECT DISTINCT cs.id_category, cs.id_shop FROM `'._DB_PREFIX_.'category_shop` cs
					WHERE cs.id_shop = '.Shop::getContextShopID(true).')
			AND cr.id_shop = '.(int)Shop::getContextShopID(true).';');
		}
		else
		{
			return Db::getInstance()->ExecuteS('SELECT cr.id_category
				FROM '._DB_PREFIX_.'ae_category_repository cr
				WHERE cr.id_category NOT IN (SELECT DISTINCT c.id_category FROM `'._DB_PREFIX_.'category` c);');
		}
	}

	public static function getCategoryList($clause, $bulk)
	{
		if (Context::getContext()->shop->isFeatureActive())
		{
			return Db::getInstance()->executeS('SELECT DISTINCT c.id_category, c.date_upd, c.id_parent
				FROM `'._DB_PREFIX_.'category` c, `'._DB_PREFIX_.'category_shop` cs
				'.$clause.'
				AND c.id_category = cs.id_category
				AND cs.id_shop = '.(int)Shop::getContextShopID(true).'
				ORDER BY c.id_category
				LIMIT 0,'.(int)$bulk.';');
		}
		else
		{
			return Db::getInstance()->executeS('SELECT DISTINCT c.id_category, c.date_upd, c.id_parent
				FROM `'._DB_PREFIX_.'category` c
				'.$clause.'
				ORDER BY c.id_category
				LIMIT 0,'.(int)$bulk.';');
		}
	}

	public static function getCategoryFeatures($category_id)
	{
		$active_lang = !AELibrary::isEmpty(AEAdapter::getActiveLanguageIds()) ? 'AND l.id_lang IN ('.AEAdapter::getActiveLanguageIds().')' : '';
		return Db::getInstance()->ExecuteS(
			'SELECT DISTINCT c.id_parent, l.iso_code, cl.name, cl.description
			FROM '._DB_PREFIX_.'category_group cg, '._DB_PREFIX_.'category c, '._DB_PREFIX_.'category_lang cl, '._DB_PREFIX_.'lang l
			WHERE c.id_category = cg.id_category
			AND cl.id_lang = l.id_lang
			AND c.id_category = cl.id_category
			'.$active_lang.'
			AND c.id_category = '.(int)$category_id);
	}

	public static function insertCategory($category)
	{
		$multishop = (Context::getContext()->shop->isFeatureActive()) ? Shop::getContextShopID(true) : 1;
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_category_repository` VALUES('.(int)$category->categoryId.', '.(int)$multishop.'
			,\''.pSQL($category->updateDate).'\');');
	}

	public static function updateCategory($category)
	{
		$multishop = (Context::getContext()->shop->isFeatureActive()) ? Shop::getContextShopID(true) : 1;
		Db::getInstance()->execute('UPDATE `'._DB_PREFIX_.'ae_category_repository` SET date_upd = \''.pSQL($category->updateDate).'\'
			WHERE id_category = '.(int)$category->categoryId.' AND id_shop = '.(int)$multishop.';');
	}

	public static function deleteCategory($category)
	{
		$multishop = (Context::getContext()->shop->isFeatureActive()) ? Shop::getContextShopID(true) : 1;
		Db::getInstance()->execute('DELETE FROM `'._DB_PREFIX_.'ae_category_repository` WHERE id_category = '.(int)$category->categoryId.'
			AND id_shop = '.(int)$multishop.';');
	}

}

?>