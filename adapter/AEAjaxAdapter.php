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

require_once(dirname(__FILE__).'/../loader.php');

class AEAjaxAdapter {

	public static function stackRead($product_id)
	{
		$cookies = AECookie::getInstance();
		$cookie_reco_last_seen = unserialize($cookies->getCookie()->__get('recoLastSeen'));
		$reco_last_seen = is_array($cookie_reco_last_seen) ? $cookie_reco_last_seen : array();
		array_push($reco_last_seen, $product_id);
		$cookies->getCookie()->__set('recoLastSeen', serialize($reco_last_seen));
	}

	public static function initHosts()
	{
		$hosts = unserialize(AEAdapter::getLocalHosts());
		if (!is_array($hosts))
			$hosts = array();
		if (!in_array($_SERVER['SERVER_ADDR'], $hosts))
		{
			array_push($hosts, $_SERVER['SERVER_ADDR']);
			AEAdapter::setLocalHosts(serialize($hosts));
		}
	}

	public static function authentication()
	{
		if (!Tools::getValue('aetoken') || Tools::getValue('aetoken') != AEAdapter::getBackOfficeToken())
			die('ERROR');

		$ini = parse_ini_file(dirname(__FILE__).'/../configuration/configuration.ini');

		$ret = array();

		if (Tools::getIsset('email') && Tools::getIsset('password'))
		{
			$customer = new stdClass();
			$customer->siteName = AEAdapter::getShopName();
			$customer->email = Tools::safeOutput(Tools::getValue('email'));
			$customer->password = Tools::safeOutput(Tools::getValue('password'));

			if (_PS_VERSION_ >= '1.5')
			{
				if (!AELibrary::isEmpty(ShopUrl::getMainShopDomain(Shop::getContextShopID(true))))
					$customer->domain = ShopUrl::getMainShopDomain(Shop::getContextShopID(true));
				else
					$ret['_errorMessage'] = 'We can find your shop URL';
			}
			else
				$customer->domain = Tools::getHttpHost();

			$customer->origin = $ini['origin'];
			$customer->platform = 'Prestashop';
			$customer->platformVersion = _PS_VERSION_;
			$customer->ip = $_SERVER['SERVER_ADDR'];

			if (Tools::safeOutput(Tools::getValue('action')) == 'register')
			{
				if (Tools::getIsset('discountCode') && !AELibrary::isEmpty(Tools::getValue('discountCode')))
					$customer->code = Tools::safeOutput(Tools::getValue('discountCode'));

				$request = new CustomerRequest($customer);
				$response = $request->registerCustomer();	
			}

			if ($response)
			{
				if ($response->_ok == 'true')
				{
					AEAdapter::authentication($response->email, '',
						$response->siteId, $response->securityKey);
					self::initHosts();
				}
				else
					$ret['_errorMessage'] = $response->_errorMessage;
				$ret['_ok'] = $response->_ok;
			}
			else
				$ret['_ok'] = false;
		}

		return Tools::jsonEncode($ret);
	}

	public static function setProperty()
	{
		if (!Tools::getValue('aetoken') || Tools::getValue('aetoken') != AEAdapter::getBackOfficeToken())
			die('ERROR');

		$response = array();

		if (Tools::getIsset('percentage'))
		{
			try {
				AEAdapter::setAbTestingPercentage(Tools::safeOutput(Tools::getValue('percentage')));
				AELogger::log('[INFO]', 'A/B Testing percentage has changed : '.Tools::safeOutput(Tools::getValue('percentage')).'%');
				$response['_ok'] = true;
			} catch (Exception $e)
			{
				AELogger::log('[ERROR]', $e->getMessage());
				$response['_ok'] = false;
			}
		}
		else if (Tools::getIsset('activation'))
		{
			try {
				AEAdapter::setActiveRecommendation(Tools::safeOutput(Tools::getValue('activation')));
				if ((int)Tools::getValue('activation') === 1)
					Configuration::updateValue('AFFINITYITEMS_CONFIGURATION_OK', true);
				AELogger::log('[INFO]', 'Recommendation Activation : '.Tools::safeOutput(Tools::getValue('activation')));
				$response['_ok'] = true;
			} catch (Exception $e)
			{
				AELogger::log('[ERROR]', $e->getMessage());
				$response['_ok'] = false;
			}
		}

		return Tools::jsonEncode($response);
	}

	public static function setHosts()
	{
		if (!Tools::getValue('aetoken') || Tools::getValue('aetoken') != AEAdapter::getBackOfficeToken())
			die('ERROR');

		$response = array();

		if (Tools::getIsset('ip') && Tools::getIsset('type'))
		{
			if (Tools::safeOutput(Tools::getValue('type')) == 'local')
			{
				try {
					$hosts = unserialize(AEAdapter::getLocalHosts());
					if (!is_array($hosts))
						$hosts = array();
					if (preg_match(AELibrary::$check_ip, Tools::safeOutput(Tools::getValue('ip'))))
					{
						array_push($hosts, Tools::getValue('ip'));
						AEAdapter::setLocalHosts(serialize($hosts));
						$response['_ok'] = true;
					}
					else
						$response['_ok'] = false;
				} catch(Exception $e)
				{
					$response['_ok'] = false;
					AELogger::log('[ERROR]', $e->getMessage());
				}
			}
		}
		else if (Tools::getIsset('ipList') && Tools::getIsset('type'))
		{
			if (Tools::safeOutput(Tools::getValue('type')) == 'remote')
			{
				try {
					$host_request = new HostRequest(Tools::getValue('ipList'));
					if ($host_request->post())
						$response['_ok'] = true;
					else
						$response['_ok'] = false;
				} catch(Exception $e)
				{
					$response['_ok'] = false;
					AELogger::log('[ERROR]', $e->getMessage());
				}
			}
		}

		return Tools::jsonEncode($response);
	}

	public static function resetSync()
	{
		Synchronize::setLock(0);
		Synchronize::setStartDate('');
	}

	public static function launchSync()
	{
		$response = array();
		try {
			if (!AELibrary::isEmpty(AEAdapter::getSiteId())
				&& !AELibrary::isEmpty(AEAdapter::getSecurityKey()))
			{
				$sync = new Synchronize();
				$sync->syncElement();
			}
			$response['_ok'] = true;
		} catch (Exception $e)
		{
			AELogger::log('[ERROR]', $e->getMessage());
			$response['_ok'] = false;
		}
	}

	public static function checkSyncDiff()
	{
		return (((time() - Synchronize::getStartDate()) > (AEAdapter::getSyncDiff() * 60)));
	}

	public static function synchronize()
	{
		$response = array();

		if (Tools::getIsset('synchronize'))
		{
			if ((bool)Synchronize::getLock())
			{
				if (!AELibrary::isEmpty(Synchronize::getStartDate()))
				{
					if (self::checkSyncDiff())
					{
						self::resetSync();
						self::launchSync();
					}
				}
			}
			else
			{
				if (!AELibrary::isEmpty(Synchronize::getStartDate()))
				{
					if (self::checkSyncDiff())
						self::launchSync();
				}
				else
					self::launchSync();
			}
		}
		if (Tools::getIsset('getInformation'))
		{
			$response['_ok'] = true;
			$response['_activate'] = AEAdapter::getActiveRecommendation();
			$response['_step'] = ((int)Synchronize::getStep() + 1);
			$response['_lock'] = (bool)Synchronize::getLock();
			$response['_lastStart'] = Synchronize::getStartDate();
			$response['_percentage'] = (((int)Synchronize::getStep() + 1) * (100 / 5));
		}

		return Tools::jsonEncode($response);
	}

	public static function postAction()
	{
		if ((Tools::getIsset('productId') || Tools::getIsset('categoryId')) && Tools::getIsset('action'))
		{
			$instance = new AffinityItems();
			$person = $instance->getPerson();

			$action = new stdClass();
			if (Tools::getValue('productId'))
				$action->productId = (int)Tools::getValue('productId');
			if (Tools::getValue('categoryId'))
				$action->categoryId = (int)Tools::getValue('categoryId');
			if (Tools::getIsset('recoType'))
				$action->recoType = Tools::safeOutput(Tools::strtoupper(Tools::getValue('recoType')));
			$action->context = Tools::safeOutput(Tools::getValue('action'));

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

			$content = $action;
			$request = new ActionRequest($content);

			if (!AELibrary::isEmpty(AEAdapter::getSiteId())
				&& !AELibrary::isEmpty(AEAdapter::getSecurityKey()))
			{
				if (!$request->post())
				{
					$repository = new ActionRepository();
					$repository->insert(AELibrary::castArray($content));
				}
			}

			if (AELibrary::equals($action->context, 'read') && Tools::getValue('productId'))
				self::stackRead($action->productId);

			return Tools::jsonEncode((array('_ok' => true)));
		}
		else
			return Tools::jsonEncode((array('_ok' => false)));
	}

	public static function syncNotification()
	{
		if (!Tools::getValue('aetoken') || Tools::getValue('aetoken') != AEAdapter::getBackOfficeToken())
			die('ERROR');

		$response = array();

		if (Tools::getIsset('notificationId'))
		{
			try {
				$notification = new stdClass();
				$notification->id = Tools::safeOutput(Tools::getValue('notificationId'));
				$notifications = array($notification);
				$instance = new AENotification($notifications);
				$instance->syncUpdateElement();
				$response['_ok'] = true;
			} catch(Exception $e)
			{
				AELogger::log('[ERROR]', $e->getMessage());
				$response['_ok'] = false;
			}
		}

		return Tools::jsonEncode($response);
	}

	public static function closeFunnel()
	{
		$response = array();
		try 
		{
			Configuration::updateValue('AE_FUNNEL', 1);
			$response['_ok'] = true;			
		}
		catch(Exception $e)
		{
			AELogger::log('[ERROR]', $e->getMessage());
			$response['_ok'] = false;
		}

		return Tools::jsonEncode($response);
	}

	public static function support()
	{
		$response = array();
		try 
		{
			$content = new stdClass();
			if (Tools::getIsset('help')) 
			{
				$content->help = true;
				$content->firstname = Tools::safeOutput(Tools::getValue('firstname'));
				$content->lastname = Tools::safeOutput(Tools::getValue('lastname'));
				$content->phone = Tools::safeOutput(Tools::getValue('phone'));
			} 
			else if (Tools::getIsset('desactivate'))
			{
				$content->desactivate = true;
				$content->reason = Tools::safeOutput(Tools::getValue('reason'));
			}
			$request = new SupportRequest($content);
			if ($request->post())
				$response['_ok'] = true;
		}
		catch(Exception $e)
		{
			AELogger::log('[ERROR]', $e->getMessage());
			$response['_ok'] = false;
		}

		return Tools::jsonEncode($response);
	}

	public static function preview()
	{
		if (!Tools::getValue('aetoken') || Tools::getValue('aetoken') != AEAdapter::getBackOfficeToken())
			die('ERROR');
		
		$response = array();
		try {
			$aepreview = AECookie::getInstance();
			$aepreview->getPreview()->__set('aepreview', 'true');
			$aepreview->getPreview()->write();
			$response['_ok'] = true;
		}
		catch(Exception $e)
		{
			AELogger::log('[ERROR]', $e->getMessage());
			$response['_ok'] = false;
		}

		return Tools::jsonEncode($response);

	}

}

