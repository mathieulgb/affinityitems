<?php
/**
* 2014 Affinity-Engine
*
* NOTICE OF LICENSE
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade AffinityItems to newer
* versions in the future.If you wish to customize AffinityItems for your
* needs please refer to http://www.affinity-engine.fr for more information.
*
*  @author    Affinity-Engine SARL <contact@affinity-engine.fr>
*  @copyright 2014 Affinity-Engine SARL
*  @license   http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL Version 2 (GPLv2)
*  International Registered Trademark & Property of Affinity Engine SARL
*/

require_once('loader.php');

if (!defined('_PS_VERSION_'))
	exit;

if (!defined('_MYSQL_ENGINE_'))
	define('_MYSQL_ENGINE_', 'MyISAM');

class AffinityItems extends Module {

	public $category_synchronize;

	public $product_synchronize;

	public $order_synchronize;

	public $action_synchronize;

	public $aecookie;

	public static $hook_list = array('Home', 'Left', 'Right', 'Cart', 'Product', 'Search', 'Category');

	public static $crawler_list = 'Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler
	|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby|bot';

	public function __construct()
	{
		$this->name = 'affinityitems';
		$this->tab = 'advertising_marketing';
		$this->version = '2.1.1';
		$this->author = 'Affinity Engine';
		parent::__construct();

		if (!extension_loaded('curl') || !ini_get('allow_url_fopen'))
		{
			if (!extension_loaded('curl') && !ini_get('allow_url_fopen'))
				$this->warning = $this->l('You must enable cURL extension and allow_url_fopen option on your server if you want to use this module.');
			else if (!extension_loaded('curl'))
				$this->warning = $this->l('You must enable cURL extension on your server if you want to use this module.');
			else if (!ini_get('allow_url_fopen'))
				$this->warning = $this->l('You must enable allow_url_fopen option on your server if you want to use this module.');
		}

		if (_PS_VERSION_ < '1.5')
			require(_PS_MODULE_DIR_.$this->name.'/backward_compatibility/backward.php');

		$this->categorySynchronize = new CategorySynchronize();
		$this->productSynchronize = new ProductSynchronize();
		$this->orderSynchronize = new OrderSynchronize();
		$this->actionSynchronize = new ActionSynchronize();
		$this->aecookie = AECookie::getInstance();

		Configuration::updateValue('AE_CONF_HOST', 'json.production.affinityitems.com');
		Configuration::updateValue('AE_CONF_PORT', 80);

		$this->displayName = $this->l('Affinity Items');
		$this->description = $this->l('Improve your sales by 10 to 60% with a personalized merchandizing: offer the appropriate products to each visitor.');
		$this->confirmUninstall = $this->l('Are you sure you want to uninstall?');
		$this->checkForUpdates();
	}


	private function _createAjaxController()
	{
		$tab = new Tab();
		$tab->active = 1;
		foreach (Language::getLanguages(false) as $language)
			$tab->name[$language['id_lang']] = 'AffinityItems';
		$tab->class_name = 'AEAjax';
		$tab->module = $this->name;
		$tab->id_parent = -1;
		if (!$tab->add())
			return false;
		return true;
	}

	private function _removeAjaxContoller()
	{
		$tab_id = (int)Tab::getIdFromClassName('AEAjax');
		if ($tab_id)
		{
			$tab = new Tab($tab_id);
			$tab->delete();
		}
		return true;
	}

	public static function hasKey($key)
	{
		if (version_compare(_PS_VERSION_, '1.5', '>='))
			return Configuration::hasKey($key);
		else
			return Configuration::get($key);
	}

	public static function updateGlobalValue($key, $value)
	{
		if (version_compare(_PS_VERSION_, '1.5', '>='))
			Configuration::updateGlobalValue($key, $value);
		else
			Configuration::updateValue($key, $value);
	}

	public function install()
	{
		$sql = array();
		$properties = array();
		$hook_list = array();

		include(dirname(__FILE__).'/configuration/hookList.php');
		include(dirname(__FILE__).'/configuration/properties.php');
		include(dirname(__FILE__).'/configuration/sqlinstall.php');

		if (parent::install())
		{
			foreach ($sql as $s)
			{
				if (!Db::getInstance()->execute($s))
					return false;
			}

			foreach ($properties as $key => $value)
			{
				if (!(self::hasKey($key)))
					self::updateGlobalValue($key, $value);
			}

			foreach ($hook_list as $hook)
			{
				if (!$this->registerHook($hook))
					return false;
			}

			if (version_compare(_PS_VERSION_, '1.5', '>='))
			{
				if (!$this->_createAjaxController())
					return false;
			}

			if (version_compare(_PS_VERSION_, '1.5', '>='))
			{
				if (!AELibrary::isEmpty(ShopUrl::getMainShopDomain(Shop::getContextShopID(true))))
					$domain = ShopUrl::getMainShopDomain(Shop::getContextShopID(true));
				else
					$domain = 'Can\'t find your shop URL';
			}
			else
				$domain = Tools::getHttpHost();

			try 
			{
				$install_request = new InstallRequest(array('domain' => $domain));
				$install_request->post();
			} 
			catch(Exception $e)
			{
				AELogger::log('[INFO]', $e->getMessage());
			}

			return true;
		}
		else
			return false;
	}

	public function uninstall()
	{
		$sql = array();
		$properties = array();
		$hook_list = array();

		include(dirname(__FILE__).'/configuration/hookList.php');
		include(dirname(__FILE__).'/configuration/properties.php');
		include(dirname(__FILE__).'/configuration/sqluninstall.php');

		if (parent::uninstall())
		{
			if (self::isConfig() && self::isLastSync())
			{
				try {
					$disable_request = new DisableRequest((bool)Configuration::get('AE_BREAK_CONTRACT'));
					$disable_request->post();
				} catch(Exception $e)
				{
					AELogger::log('[INFO]', $e->getMessage());
				}
			}

			foreach ($sql as $s)
			{
				if (!Db::getInstance()->execute($s))
					return false;
			}

			foreach (array_keys($properties) as $key)
				Configuration::deleteByName($key);

			foreach ($hook_list as $hook)
			{
				if (!$this->unregisterHook($hook))
					return false;
			}

			if (version_compare(_PS_VERSION_, '1.5', '>='))
			{
				if (!$this->_removeAjaxContoller())
					return false;
			}

			return true;
		}
		else
			return false;
	}

	public function hookBackOfficeHeader()
	{
		$this->generateGuest();
		$aecookie = AECookie::getInstance();
		ABTesting::init();
		$aecookie->getCookie()->__set('aegroup', 'Z');
		$aecookie->getCookie()->write();
	}

	public function setVisit($page)
	{
		$person = $this->getPerson();
		$action = new stdClass();
		$action->context = 'visit';
		$action->page = $page;
		if ($person instanceof stdClass)
			exit;
		else if ($person instanceof AEGuest)
			$action->guestId = $person->personId;
		if (Context::getContext()->customer->isLogged())
			$action->memberId = Context::getContext()->cookie->id_customer;
		if ($group = $person->getGroup())
			$action->group = $group;
		if (!AELibrary::isEmpty(Tools::getRemoteAddr()))
			$action->ip = Tools::getRemoteAddr();
		if (!AELibrary::isEmpty(Context::getContext()->language->iso_code))
			$action->language = Context::getContext()->language->iso_code;
		$request = new ActionRequest($action);
		try {
			$request->post();
		} catch (Exception $e) {
			error_log($e);
		}
	}

	public function hookheader()
	{
		$this->context->controller->addJS(($this->_path).'js/affinityitems.js');
		$this->context->controller->addCSS(($this->_path).'css/'.Tools::substr(str_replace('.', '', _PS_VERSION_), 0, 2).'/aefront.css', 'all');
		if (isset($_SERVER['HTTP_USER_AGENT']))
		{
			if (!preg_match('/'.self::$crawler_list.'/i', $_SERVER['HTTP_USER_AGENT']) > 0)
			{
				$this->generateGuest();
				if (Tools::getValue('aeabtesting'))
					ABTesting::forceGroup(Tools::getValue('aeabtesting'));
				ABTesting::init();
			}
		}

		return $this->renderSpecialHook();
	}

	/*
	 *
	 * hook category part
	 *
	*/

	public function hookcategoryAddition()
	{
		if (self::isConfig() && self::isLastSync())
			$this->categorySynchronize->syncNewElement();
	}

	public function hookcategoryUpdate()
	{
		if (self::isConfig() && self::isLastSync())
			$this->categorySynchronize->syncUpdateElement();
	}

	public function hookcategoryDeletion()
	{
		if (self::isConfig() && self::isLastSync())
			$this->categorySynchronize->syncDeleteElement();
	}

	/*
	 *
	 * hook member part
	 *
	*/


	public function linkGuestToMember($member_id)
	{
		if (self::isConfig() && self::isLastSync())
		{
			if ($this->aecookie->getCookie()->__isset('aeguest') && !AELibrary::isEmpty($member_id))
			{
				$person = $this->getPerson();
				try {
					$data = new stdClass();
					$data->guestId = (String)$this->aecookie->getCookie()->__get('aeguest');
					$data->memberId = (String)$member_id;
					if ($group = $person->getGroup())
						$data->group = (String)$group;
					$request = new LinkGuestToMemberRequest($data);
					$request->post();
				} catch(Exception $e)
				{
					AELogger::log('[ERROR]', $e->getMessage());
				}
			}
		}
	}

	public function hookcreateAccount($params)
	{
		$this->linkGuestToMember($params['newCustomer']->id);
	}

	public function hookauthentication($params)
	{
		$this->linkGuestToMember($params['cart']->id_customer);
	}

	/*
	 *
	 * hook product part
	 *
	*/

	public function hookaddproduct()
	{
		if (self::isConfig() && self::isLastSync())
			$this->productSynchronize->syncNewElement();
	}

	public function hookupdateproduct()
	{
		if (self::isConfig() && self::isLastSync())
			$this->productSynchronize->syncUpdateElement();
	}

	public function hookdeleteproduct()
	{
		if (self::isConfig() && self::isLastSync())
			$this->productSynchronize->syncDeleteElement();
	}

	public function hookupdateProductAttribute()
	{
		if (self::isConfig() && self::isLastSync())
			$this->productSynchronize->syncNewElement();
	}

	/*
	 *
	 * hook cart
	 *
	*/

	public function extractProductIds($items) 
	{
		$products = array();
		if (is_array($items))
			foreach ($items as $item)
				if (isset($item->id))
					$products[] = $item->id;
				else
					$products[] = $item['id_product'];
		return $products;
	}

	public function cartOperation($cart, $aecontext, $product)
	{
		$aecart = new stdClass();
		$aecart->context = $aecontext;
		
		$orderLine = new stdClass();
		$orderLine->productId = $product->id;
		$orderLine->quantity = $product->quantity;
		$orderLine->attributeIds = $product->attributes;
		$aecart->orderLine = $orderLine;
		
		if ($cart->id_customer <> 0)
			$aecart->memberId = $cart->id_customer;

		$aecart->guestId = (String)$this->aecookie->getCookie()->__get('aeguest');

		if (AEAdapter::isLastSync())
			if ($group = AEAdapter::getCartGroup($cart->id))
				$aecart->group = $group;
		if (!AELibrary::isEmpty(Tools::getRemoteAddr()) && !(bool)Synchronize::getLock())
			$aecart->ip = Tools::getRemoteAddr();
		if (!AELibrary::isEmpty(Context::getContext()->language->iso_code) && !(bool)Synchronize::getLock())
			$aecart->language = Context::getContext()->language->iso_code;
		$request = new ActionRequest($aecart);
		$request->post();
	}

	public function addToCart($cart)
	{
		$products = $cart->getProducts();
		$aeproducts = is_array(unserialize($this->aecookie->getCart()->__get('cart'))) ? unserialize($this->aecookie->getCart()->__get('cart')) : array();
		foreach ($products as $product) 
		{
			if (!in_array($product['id_product'], $this->extractProductIds($aeproducts))) 
			{
				$prod = new stdClass();
				$prod->id = $product['id_product'];
				$prod->quantity = $product['cart_quantity'];
				$prod->attributes = $this->getCartsProductAttributes($product['id_product_attribute']);
				$this->cartOperation($cart, 'addToCart', $prod);
				array_push($aeproducts, $prod);
			}
		}
		$this->aecookie->getCart()->__set('cart', serialize($aeproducts));
		$this->aecookie->getCookie()->write();
	}

	public function removeFromCart($cart)
	{
		$products = $cart->getProducts();
		$aeproducts = is_array(unserialize($this->aecookie->getCart()->__get('cart'))) ? unserialize($this->aecookie->getCart()->__get('cart')) : array();
		foreach ($aeproducts as $key => $product) 
		{
			if (!in_array($product->id, $this->extractProductIds($products)))
			{
				$prod = new stdClass();
				$prod->id = $product->id;
				$prod->quantity = $product->quantity;
				$prod->attributes = $product->attributes;
				$this->cartOperation($cart, 'removeFromCart', $prod);				
				unset($aeproducts[$key]);
			}
		}
		$this->aecookie->getCart()->__set('cart', serialize($aeproducts));
		$this->aecookie->getCookie()->write();
	}

	public function hookCart($params)
	{
		if (self::isConfig() && self::isLastSync())
		{
			$person = $this->getPerson();
			if (isset($params['cart']->id) && $person instanceof AEGuest)
			{
				AEAdapter::setCartGroup($params['cart']->id, $person->getGroup(), $person->getPersonId(), Tools::getRemoteAddr());
				$cart = new Cart((int)$params['cart']->id);
				$this->addToCart($cart);
				$this->removeFromCart($cart);
			}
		}
	}

	/*
	 *
	 * hook new order
	 *
	*/

	public function hookactionObjectOrderAddAfter()
	{
		if (self::isConfig() && self::isLastSync())
			$this->orderSynchronize->syncNewElement();
	}

	/*
	 *
	 * hook recommendation
	 *
	*/

	public function getRecommendation($aecontext, $stack)
	{
		if (!AELibrary::isEmpty(Tools::getRemoteAddr()))
			$aecontext->ip = Tools::getRemoteAddr();
		if (!AELibrary::isEmpty(Context::getContext()->language->iso_code))
			$aecontext->language = Context::getContext()->language->iso_code;
		$recommendation = new Recommendation($aecontext, $this->context, $stack, true);
		$products = $recommendation->getRecommendation();
		return $products;
	}


	public function formatConfiguration($configuration, $hook_name, $index)
	{
		$hook_configuration = new stdClass();
		foreach ($configuration as $key => $value)
		{
			$k = str_replace($hook_name, '', $key);
			$j = preg_replace('/_'.$index.'+/i', '', $k);
			$hook_configuration->{$j} = $value;
		}
		return $hook_configuration;
	}

	public function preg_match_count_object_key($pattern, $subject)
	{
		$i = 0;
		foreach ($subject as $key => $value)
		{
			if (preg_match($pattern, $key))
				$i++;
		}
		return $i;
	}

	public static function splitBySemicolon($field)
	{
		$response = explode(';', $field);
		return !$response ? array() : $response;
	}

	public function getCartOrderLines($params)
	{
		$order_lines = array();
		foreach ($params['products'] as $value)
		{
			$order_line = new stdClass();
			$order_line->productId = $value['id_product'];
			$order_line->attributeIds = $this->getCartsProductAttributes($value['id_product_attribute']);
			$order_line->quantity = $value['cart_quantity'];
			$order_lines[] = $order_line;
		}
		return $order_lines;
	}

	public function getCartsProductAttributes($product_attribute_id)
	{
		$attribute_ids = array();
		$attributes = ProductAdapter::getProductAttributesByAttributeId($product_attribute_id);
		foreach ($attributes as $attribute)
			$attribute_ids[] = $attribute['id_attribute'];
		return $attribute_ids;
	}

	public function prepareRecommendation($hook, $params = null)
	{
		$recommendations = array();
		$render = array();
		$hook_configuration = unserialize(Configuration::get('AE_CONFIGURATION_'.Tools::strtoupper($hook)));
		$occurrence = $this->preg_match_count_object_key('/reco'.$hook.'/i', $hook_configuration);
		if (self::isConfig() && self::isLastSync() && (bool)Configuration::get('AE_RECOMMENDATION'))
		{
			for ($i = 1; $i <= $occurrence; $i++)
			{
				$aecontext = new stdClass();
				if ((bool)$hook_configuration->{'reco'.$hook.'_'.$i})
				{
					$aecontext->context = $hook_configuration->{'recoType'.$hook.'_'.$i};
					if (in_array($hook, array('Home', 'Left', 'Right'))) 
					{
						if (AELibrary::equals($hook_configuration->{'recoType'.$hook.'_'.$i}, 'recoAllFiltered'))
						{
							if (!AELibrary::equals($hook_configuration->{'recoFilter'.$hook.'_'.$i}, 'onSale'))
							{
								$aecontext->{Tools::strtolower(preg_replace('/by/i', '', $hook_configuration->{'recoFilter'.$hook.'_'.$i})).'Ids'} =
								self::splitBySemicolon($hook_configuration->{Tools::strtolower(preg_replace('/by/i', '', $hook_configuration->{'recoFilter'.$hook.'_'.$i})).'Ids'.$hook.'_'.$i});
							}
							else
								$aecontext->{$hook_configuration->{'recoFilter'.$hook.'_'.$i}} = true;
						}
					}
					else if ($hook == 'Product')
						$aecontext->productId = (string)Tools::getValue('id_product');
					else if ($hook == 'Cart')
						$aecontext->orderLines = $this->getCartOrderLines($params);
					else if ($hook == 'Category')
						$aecontext->categoryId = $params;
					else if ($hook == 'Search')
						$aecontext->keywords = $params;

					$aecontext->area = Tools::strtoupper($hook);
					$aecontext->size = (int)$hook_configuration->{'recoSize'.$hook.'_'.$i};
					$products = $this->getRecommendation($aecontext, false);
					$theme = AEAdapter::getThemeById($hook_configuration->{'recoTheme'.$hook.'_'.$i});
					array_push($recommendations, array('aeproducts' => $products,
						'theme' => unserialize($theme[0]['configuration']), 'configuration' => $hook_configuration, 'titleZone' => $hook_configuration->{'recoTitle'.$hook.'_'.$i}));
					if (in_array($hook, array('Search', 'Category')))
					{
						$this->smarty->assign(array('recommendations' => $recommendations));
						$render[] = $this->display(__FILE__, '/views/templates/hook/'.Tools::substr(str_replace('.', '', _PS_VERSION_), 0, 2).'/srecommendation.tpl');
					}
				}
			}
		}
		else
		{
			$aepreview = AECookie::getInstance();
			if ($aepreview->getPreview()->__get('aepreview'))
			{
				for ($i = 1; $i <= $occurrence; $i++)
				{
					if ((bool)$hook_configuration->{'reco'.$hook.'_'.$i})
					{
						$theme = AEAdapter::getThemeById($hook_configuration->{'recoTheme'.$hook.'_'.$i});
						array_push($recommendations, array('aeproducts' =>  AEAdapter::renderPreviewRecommendation((int)$this->context->cookie->id_lang),
							'theme' => unserialize($theme[0]['configuration']), 'configuration' => $hook_configuration, 'titleZone' => 'PREVIEW'));
						if (in_array($hook, array('Search', 'Category')))
						{
							$this->smarty->assign(array('recommendations' => $recommendations));
							$render[] = $this->display(__FILE__, '/views/templates/hook/'.Tools::substr(str_replace('.', '', _PS_VERSION_), 0, 2).'/srecommendation.tpl');
						}
					}
				}
			}
		}
		if (!empty($recommendations))
		{
			if (!in_array($hook, array('Search', 'Category'))) 
			{
				$this->smarty->assign(array('recommendations' => $recommendations));
				return $this->display(__FILE__, '/views/templates/hook/'.Tools::substr(str_replace('.', '', _PS_VERSION_), 0, 2).'/hrecommendation.tpl');
			}
			else
				return $render;
		}

	}

	public function hookHome()
	{
		return $this->prepareRecommendation('Home');
	}

	public function hookLeftColumn()
	{
		return $this->prepareRecommendation('Left');
	}

	public function hookRightColumn()
	{
		return $this->prepareRecommendation('Left');
	}

	public function hookProductFooter()
	{
		return $this->prepareRecommendation('Product');
	}

	public function hookShoppingCart($params)
	{
		return $this->prepareRecommendation('Cart', $params);
	}

	public function renderCategory($category_id)
	{
		return $this->prepareRecommendation('Category', $category_id);
	}

	public function actionSearch($expr)
	{
		if (self::isConfig())
		{
			$person = $this->getPerson();
			$action = new stdClass();
			$action->context = 'search';
			$action->keywords = $expr;
			if ($person instanceof stdClass)
				exit;
			else if ($person instanceof AEGuest)
				$action->guestId = $person->personId;
			if ($group = $person->getGroup())
				$action->group = $group;
			if (!AELibrary::isEmpty(Tools::getRemoteAddr()))
				$action->ip = Tools::getRemoteAddr();
			if (!AELibrary::isEmpty(Context::getContext()->language->iso_code))
				$action->language = Context::getContext()->language->iso_code;
			if (Context::getContext()->customer->isLogged())
				$action->memberId = Context::getContext()->cookie->id_customer;
			$request = new ActionRequest($action);
			if (!$request->post())
			{
				$repository = new ActionRepository();
				$repository->insert(AELibrary::castArray($action));
			}
		}
	}

	public function renderSearch($expr)
	{
		$this->actionSearch($expr);
		return $this->prepareRecommendation('Search', $expr);
	}

	/*
	 *
	 * backoffice part
	 *
	*/

	public static function getAffinityBackContent()
	{
		$instance = new AffinityItems();
		return $instance->getContent();
	}

	public function getContent()
	{
		return $this->_displayForm();
	}

	public function _displayForm()
	{
		$html = '';
		if (_PS_VERSION_ < '1.5')
		{
			$html .= "<link rel='stylesheet' type='text/css' href='".($this->_path).'css/'.Tools::substr(str_replace('.', '', _PS_VERSION_), 0, 2)."/aefront.css' />";
			$html .= "<link rel='stylesheet' type='text/css' href='".($this->_path)."css/main.css' />";
			$html .= "<link rel='stylesheet' type='text/css' href='".($this->_path)."css/font-awesome.min.css' />";
			$html .= "<link rel='stylesheet' type='text/css' href='".($this->_path)."css/jquery.nouislider.css' />";
			$html .= "<link rel='stylesheet' type='text/css' href='".($this->_path)."css/jquery.powertip.min.css' />";
			$html .= "<link rel='stylesheet' type='text/css' href='".($this->_path)."css/introjs.min.css' />";
			$html .= "<script type='text/javascript' src='".($this->_path)."js/intro.min.js'></script>";
			$html .= "<script type='text/javascript' src='".($this->_path)."js/jquery.nouislider.min.js'></script>";
			$html .= "<script type='text/javascript' src='".($this->_path)."js/jquery.powertip.min.js'></script>";
		}
		else
		{
			$this->context->controller->addCSS(($this->_path).'css/'.Tools::substr(str_replace('.', '', _PS_VERSION_), 0, 2).'/aefront.css', 'all');
			$this->context->controller->addCSS(($this->_path).'css/main.css', 'all');
			$this->context->controller->addCSS(($this->_path).'css/font-awesome.min.css', 'all');
			$this->context->controller->addCSS(($this->_path).'css/jquery.nouislider.css', 'all');
			$this->context->controller->addCSS(($this->_path).'css/jquery.powertip.min.css', 'all');
			$this->context->controller->addCSS(($this->_path).'css/introjs.min.css', 'all');
			$this->context->controller->addJS(($this->_path).'js/intro.min.js');
			$this->context->controller->addJS(($this->_path).'js/jquery.nouislider.min.js');
			$this->context->controller->addJS(($this->_path).'js/jquery.powertip.min.js');
		}
		if (self::isConfig())
			return $html.$this->getDashboard();
		else
			return $html.$this->getAuthentication();
	}

	public function getDashboard()
	{
		$html = '';

		if ($this->postProcess())
			$html .= Module::displayConfirmation($this->l('Settings updated.'));

		$site_request = new SiteRequest(array());
		$data = $site_request->get();
		$protocol_link = (Configuration::get('PS_SSL_ENABLED') || Tools::usingSecureMode()) ? 'https://' : 'http://';
		$use_s_s_l = ((isset($this->ssl) && $this->ssl && Configuration::get('PS_SSL_ENABLED')) || Tools::usingSecureMode()) ? true : false;
		$protocol_content = ($use_s_s_l) ? 'https://' : 'http://';

		if (_PS_VERSION_ >= '1.5')
			$theme_id = Tools::getValue('id_theme') ? Tools::getValue('id_theme') : AEAdapter::getLastCreatedTheme();
		else
			$theme_id = Tools::getValue('id_theme') ? Tools::getValue('id_theme') : 1;

		$theme = AEAdapter::getThemeById($theme_id);
		$theme_selected = array('themeId' => $theme_id, 'themeConfiguration' => unserialize($theme[0]['configuration']));
		$theme_list = AEAdapter::getThemeList();
		$configuration = array();

		foreach (self::$hook_list as $hook)
		{
			$hook_configuration = unserialize(Configuration::get('AE_CONFIGURATION_'.Tools::strtoupper($hook)));
			$configuration[$hook] = $hook_configuration;
		}

		$this->context->smarty->assign(array(
			'version' => Tools::substr(str_replace('.', '', _PS_VERSION_), 0, 2),
			'baseUrl' =>  version_compare(_PS_VERSION_, '1.5', '>=') ? $this->context->shop->getBaseURL() : __PS_BASE_URI__,
			'isConfig' => Configuration::get('AE_FUNNEL'),
			'siteId' => Configuration::get('AE_SITE_ID'),
			'aetoken' => Configuration::get('AE_BACKOFFICE_TOKEN'),
			'data' => $data,
			'statistics' => isset($data->statistics) ? Tools::jsonDecode($data->statistics) : array(),
			'notifications' => $this->getNotification($data),
			'abtestingPercentage' => Configuration::get('AE_A_TESTING'),
			'recommendation' => Configuration::get('AE_RECOMMENDATION'),
			'recommendations' => array(array('aeproducts' => AEAdapter::renderPreviewRecommendation((int)$this->context->cookie->id_lang), 'theme' => $theme_selected['themeConfiguration'])),
			'link' => new Link($protocol_link, $protocol_content),
			'priceDisplay' => Product::getTaxCalculationMethod((int)$this->context->cookie->id_customer),
			'PS_CATALOG_MODE' => (bool)Configuration::get('PS_CATALOG_MODE'),
			'blacklist' => unserialize(Configuration::get('AE_AB_TESTING_BLACKLIST')),
			'breakContract' => Configuration::get('AE_BREAK_CONTRACT'),
			'syncDiff' => Configuration::get('AE_SYNC_DIFF'),
			'logs' => AELogger::getLog(),
			'hookList' => self::$hook_list,
			'themeList' => $theme_list,
			'themeSelected' => $theme_selected,
			'ajaxController' => version_compare(_PS_VERSION_, '1.5', '>=') ? true : false,
			'prestashopToken' => Tools::getAdminToken('AEAjax'.(int)Tab::getIdFromClassName('AEAjax').(int)$this->context->cookie->id_employee),
			'configuration' => $configuration,
			'additionalCss' => Configuration::get('AE_ADDITIONAL_CSS'),
			'imgSizeList' => $this->getImageSize()
			));

$html .= $this->display(($this->_path), '/views/templates/admin/dashboard.tpl');
return $html;
}

public function getAuthentication()
{
	$html = '';
	$this->context->smarty->assign(array(
		'aetoken' => Configuration::get('AE_BACKOFFICE_TOKEN'),
		'employee' => AEAdapter::getEmployeesByProfile($this->context->cookie->id_employee),
		'lang' => Context::getContext()->language->iso_code,
		'ajaxController' => version_compare(_PS_VERSION_, '1.5', '>=') ? true : false,
		'prestashopToken' => Tools::getAdminToken('AEAjax'.(int)Tab::getIdFromClassName('AEAjax').(int)$this->context->cookie->id_employee),
		'activity' => AEAdapter::getActivity()
		));
	$html .= $this->display(($this->_path), '/views/templates/admin/authentication.tpl');
	return $html;
}

public function postProcess()
{
	if (Tools::isSubmit('configZoneReco'))
	{
		$configuration = new stdClass();
		foreach (self::$hook_list as $hook)
		{
			$object = new stdClass();
			foreach ($_POST as $key => $value)
			{
				if (preg_match( '/'.$hook.'/i', $key))
					$object->{$key} = $value;
			}
			$object->area = Tools::strtolower($hook);
			$configuration->{$hook} = $object;
		}
		foreach ($configuration as $key => $value)
		{
			try {
				Configuration::updateValue('AE_CONFIGURATION_'.Tools::strtoupper($key), serialize($value));
			} catch(Exception $e)
			{
				error_log($e);
			}
		}
	}
	else if (Tools::isSubmit('themeId'))
	{
		$configuration = array();
		foreach ($_POST as $key => $value)
		{
			if (preg_match('/background|title|product|picture|price|cart|detail/i', $key))
				$configuration[$key] = $value;
		}

		if (!AELibrary::isEmpty(Tools::getValue('themeName')))
			AEAdapter::insertTheme(Tools::getValue('themeName'), serialize($configuration));
		else
			AEAdapter::updateTheme(Tools::getValue('themeId'), serialize($configuration));
		Configuration::updateValue('AE_FUNNEL', 1);
		return true;
	}
	else if (Tools::isSubmit('syncDiff') && Tools::isSubmit('blacklist'))
	{
		Configuration::updateValue('AE_SYNC_DIFF', Tools::getValue('syncDiff'));
		Tools::getValue('breakContract') ? Configuration::updateValue('AE_BREAK_CONTRACT', 1) : Configuration::updateValue('AE_BREAK_CONTRACT', 0);
		self::setBlackList(Tools::safeOutput(Tools::getValue('blacklist')));
		return true;
	}
	else if (Tools::isSubmit('graphic'))
	{
		foreach (self::$hook_list as $hook)
		{
			$configuration = unserialize(Configuration::get('AE_CONFIGURATION_'.Tools::strtoupper($hook)));
			for ($i = 1; $i <= 2; $i++) 
				$configuration->{'recoTheme'.$hook.'_'.$i} = Tools::getValue('graphic');
			Configuration::updateValue('AE_CONFIGURATION_'.Tools::strtoupper($hook), serialize($configuration));
		}
		Configuration::updateValue('AE_FUNNEL', 1);
		Configuration::updateValue('AE_RECOMMENDATION', 1);
	}
	else if (Tools::isSubmit('additionalCss'))
		Configuration::updateValue('AE_ADDITIONAL_CSS', Tools::getValue('additionalCss'));
}

	/*
	 *
	 * utils
	 *
	*/

	public function renderSpecialHook()
	{
		$hook_search_configuration = unserialize(Configuration::get('AE_CONFIGURATION_SEARCH'));
		$hook_category_configuration = unserialize(Configuration::get('AE_CONFIGURATION_CATEGORY'));

		$smarty = $this->context->smarty;
		$page = $smarty->tpl_vars['page_name']->value;

		$this->setVisit($page);
		
		if (Tools::getValue('id_category'))
			$render_category = $this->renderCategory(Tools::getValue('id_category'));
		else if (Tools::getValue('search_query'))
			$render_search = $this->renderSearch(Tools::getValue('search_query'));
		
		if (!$this->getPerson() instanceof stdClass)
		{
			$this->smarty->assign(array(
				'additionalCss' => Configuration::get('AE_ADDITIONAL_CSS'),
				'abtesting' => $this->getPerson()->getGroup(),
				'renderCategory' => isset($render_category) ? $render_category : '',
				'renderSearch' => isset($render_search) ? $render_search : '',
				'categoryId' => Tools::getValue('id_category'),
				'trackingJs' => (bool)Configuration::get('AE_TRACKING_JS'),
				'pageName' => $page,
				'hookSearchConfiguration' => $hook_search_configuration,
				'hookCategoryConfiguration' => $hook_category_configuration));

			return $this->display(__FILE__, '/views/templates/hook/hook.tpl');
		}
	}

	public function getNotification($data)
	{
		if (isset($data->notifications))
		{
			if ($data->notifications = AENotification::convert(Tools::jsonDecode($data->notifications)))
			{
				$notifications = new AENotification($data->notifications);
				$notifications = $notifications->syncNewElement();
			}
		}
		return AEAdapter::getNotifications($this->context->language->id);
	}

	public function getImageSize()
	{
		return Db::getInstance()->executeS('
			SELECT name
			FROM `'._DB_PREFIX_.'image_type`
			WHERE (name LIKE "medium%"
				OR name LIKE "home%"
				OR name LIKE "small%"
				OR name LIKE "large%")'
		);
	}

	public static function setBlackList($ip_list = array())
	{
		$black_list = array();
		try {
			if ($exp = explode(';', $ip_list))
			{
				foreach ($exp as $ip)
				{
					if (preg_match(AELibrary::$check_ip, $ip))
						$black_list[] = $ip;
				}
				Configuration::updateValue('AE_AB_TESTING_BLACKLIST', serialize($black_list));
			}
		} catch(Exception $e)
		{
			AELogger::log('[ERROR]', $e->getMessage());
		}
	}


	public static function isConfig()
	{
		return AEAdapter::isConfig();
	}

	public static function isLastSync()
	{
		if (!AELibrary::isEmpty(Configuration::get('AE_LAST_SYNC_END')))
			return true;
		return false;
	}

	public function getPerson()
	{
		$person = new stdClass();
		$guest_id = $this->aecookie->getCookie()->__isset('aeguest') ? $this->aecookie->getCookie()->__get('aeguest') : '';
		if (!AELibrary::isEmpty($guest_id))
			$person = new AEGuest($guest_id);
		return $person;
	}

	public function generateGuest()
	{
		if (!$this->aecookie->getCookie()->__isset('aeguest'))
		{
			$aeguest = str_replace('.', '', uniqid('ae', true));
			$this->aecookie->getCookie()->__set('aeguest', $aeguest);
			$this->aecookie->getCookie()->write();
		}
	}

	private function checkForUpdates()
	{
		if (version_compare(_PS_VERSION_, '1.5', '<') && self::isInstalled($this->name))
			foreach (array('1.1.0') as $version)
			{
				$file = dirname(__FILE__).'/upgrade/Upgrade-'.$version.'.php';
				if (Configuration::get('AE_VERSION') < $version && file_exists($file))
				{
				include_once($file);
				call_user_func('upgrade_module_'.str_replace('.', '_', $version), $this);
				}
			}
	}

}