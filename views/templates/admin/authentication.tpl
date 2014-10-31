{*
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
*}

{if $ajaxController}
{assign var="url" value="'index.php?controller=AEAjax&configure=affinityitems&ajax'"}
{else}
{assign var="url" value="'{$module_dir|escape:'htmlall':'UTF-8'}ajax/customer.php'"}
{/if}

<script>
{literal}
var e = /^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$/;
var v = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
var n = /^[A-Za-z0-9!@#$%^&*()_]{6,20}$/;
var r;

function error(e) {
	$(".items-alert").hide();
	$(".items-alert").empty();
	var t = "{/literal}{l s='Please enter valid data' mod='affinityitems'}{literal} : <br>";
	for (var n = 0; n < e.length; n++) {
		var r = n + 1;
		t += "\n" + r + ". " + e[n] + "<br>";
	}
	$(".items-alert").append(t);
	$(".items-alert").slideDown();
}

function yswitch() {
	var promotion = $('.items-video-promotion');
	var installation = $('.items-video-installation');
	var promotionText = $('.items-video-promotion-text');
	var installationText = $('.items-video-installation-text');
	if(promotion.is(':visible')) {
		promotion.hide();
		installation.show();
		promotionText.hide();
		installationText.show();
	} else {
		promotion.show();
		installation.hide();
		promotionText.show();
		installationText.hide();
	}
	return false;
}

$(document).ready(function () {
	$('.items-auth-switch').click(function() {
		if($('.items-register-container').is(':visible')) {
			$('.items-register-container').hide();
			$('.items-login-container').show();
		} else if($('.items-login-container').is(':visible')) {
			$('.items-login-container').hide();
			$('.items-register-container').show();
		}
		return false;
	});

	$('.items-register-container').on('submit', function() {
		r = [];
		if (!e.test($("#rfirstname").val())) {
			r[r.length] = "{/literal}{l s='Please enter a valid firstname' mod='affinityitems'}{literal}";
		}
		if (!e.test($("#rlastname").val())) {
			r[r.length] = "{/literal}{l s='Please enter a valid name' mod='affinityitems'}{literal}";
		}
		if (!v.test($("#remail").val())) {
			r[r.length] = "{/literal}{l s='Please enter a valid email address' mod='affinityitems'}{literal}";
		}
		if (!n.test($("#rpassword").val())) {
			r[r.length] = "{/literal}{l s='You password must be between 6 and 20 characters long.' mod='affinityitems'}{literal}";
		}
		if ($("#rpassword").val() != $("#rconfirmPassword").val()) {
			r[r.length] = "{/literal}{l s='The passwords do not match.' mod='affinityitems'}{literal}";
		}
		if ($("#ractivity").val() == 0) {
			r[r.length] = "{/literal}{l s='Please enter a valid activity' mod='affinityitems'}{literal}";
		}
		if ($("#rcgv").attr('checked') != "checked") {
			r[r.length] = "{/literal}{l s='You have to accept the terms and conditions of use' mod='affinityitems'}{literal}";
		}
		if (r.length > 0) {
			error(r);
			return false;
		} else {
			$.ajax({
				url: {/literal}{$url}{literal},
				type: "POST",
				async: true,
				data: {
					action: "register",
					firstname: $("#rfirstname").val(),
					lastname: $("#rlastname").val(),
					email: $("#remail").val(),
					password: $("#rpassword").val(),
					confirmPassword: $("#rconfirmPassword").val(),
					discountCode: $("#rdiscount").val(),
					activity: $("#ractivity").val(),
					token : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}",
					aetoken : '{/literal}{$aetoken}{literal}'
				},
				success: function (e, t, n) {
					var response = jQuery.parseJSON(e);
					if(response._ok == "true") {
						location.reload();
					} else {
						r = [];
						if(typeof response._errorMessage != "undefined") {
							r[r.length] = response._errorMessage;
						} else {
							r[r.length] = "{/literal}{l s='An error has occured, it seems there is no connection between your shop and our servers, please contact' mod='affinityitems'}{literal} <a href=\'mailto:mathieu@affinity-engine.fr\'>mathieu@affinity-engine.fr</a>";
						}
						error(r);
					}
				},
				error: function (e, t, n) {
					r = [];
					r[r.length] = "{/literal}{l s='An error has occured, please contact' mod='affinityitems'}{literal} <a href=\'mailto:mathieu@affinity-engine.fr\'>mathieu@affinity-engine.fr</a>";
					error(r);		
				}
			})
		}
		return false;
	});
	$('.items-login-container').on('submit', function() {
		r = [];
		if (!v.test($("#lemail").val())) {
			r[r.length] = "{/literal}{l s='Please enter a valid email address' mod='affinityitems'}{literal}";
		}
		if (!n.test($("#lpassword").val())) {
			r[r.length] = "{/literal}{l s='You password must be between 6 and 20 characters long.' mod='affinityitems'}{literal}";
		}
		if (r.length > 0) {
			error(r);
			return false;
		} else {
			$.ajax({
				url: {/literal}{$url}{literal},
				type: "POST",
				async: true,
				data: {
					action: "login",
					email: $("#lemail").val(),
					password : $("#lpassword").val(),
					token : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}",
					aetoken : '{/literal}{$aetoken}{literal}'
				},
				success: function (e, t, n) {
					var response = jQuery.parseJSON(e);
					if(response._ok == "true") {
						location.reload();
					} else {
						r = [];
						if(typeof response._errorMessage != "undefined") {
							r[r.length] = response._errorMessage;
						} else {
							r[r.length] = "{/literal}{l s='An error has occured, it seems there is no connection between your shop and our servers, please contact' mod='affinityitems'}{literal} <a href=\'mailto:mathieu@affinity-engine.fr\'>mathieu@affinity-engine.fr</a>";
						}
						error(r);
					}
				},
				error: function (e, t, n) {
					r = [];
					r[r.length] = "An error occured";
					error(r);					
				}
			});
		}
		return false;
	});
});
{/literal}
</script>
<div class="items-wrapper">
	<div class="items-header">
		<div class="aelogo"></div>
	</div>
	<div class="items-box items-line items-explain">
		<div class="items-explain-description">
			<strong>{l s='Improve your sales by up to 50%' mod='affinityitems'} <br> {l s='thanks to affinity items personnalized recommendations' mod='affinityitems'}</strong><br><br>
			<p>{l s='Propose to each visitor the products that fit his tastes & needs' mod='affinityitems'}</p>
			<p>{l s='and strongly increase your conversion rate,' mod='affinityitems'}</p>
			<p>{l s='average basket and visitors loyalty.' mod='affinityitems'}</p><br />
			<p>{l s='Contact us to benefit from our expertise and get a free set-up by our technical team.' mod='affinityitems'}</p><br />
			<p>{l s='Miss no sales: try Affinity Items!' mod='affinityitems'}</p>
		</div>
		<div class="items-video">
			<span class="items-video-promotion"><object type="text/html" data="http://www.youtube.com/embed/rxn3fHYNL3s" width="400" height="236"></object></span>
			<span class="items-video-installation"><object type="text/html" data="http://www.youtube.com/embed/AIEfj2UV-qU" width="400" height="236"></object></span>
			<a href="#" class='items-video-promotion-text' onClick='yswitch();'>{l s='how to install ?' mod='affinityitems'}</a>
			<a href="#" class='items-video-installation-text' onClick='yswitch();'>{l s='your customer\'s benefits' mod='affinityitems'}</a>
		</div>
	</div>
	<div class="clear"></div>
	{if !$configInfo.cUrl || !$configInfo.allow_url_fopen || !$configInfo.version.compatibility}
		<div class="items-alert">
			{l s='Warning : it seems that your server doesn\'t have all requirements for this module' mod='affinityitems'} :
			<ul>
				{if !$configInfo.cUrl}<li>{l s='You need cUrl library' mod='affinityitems'}</li>{/if}
				{if !$configInfo.allow_url_fopen}<li>{l s='You need enable allow_url_fopen' mod='affinityitems'}</li>{/if}
				{if !$configInfo.version.compatibility}<li>{l s='You need at least php 5.1.0' mod='affinityitems'} ({$configInfo.version.php})</li>{/if}
			</ul>
		</div>
	{/if}
	<div class="ae-info-auth"> 
		{l s='SUPPORT - Let our team install your module for free' mod='affinityitems'}
		<ul>
			<li>{l s='The technical support at' mod='affinityitems'} <span class="ae-email-color">+33 9 54 52 85 12</span> {l s='or contact' mod='affinityitems'} <a class="ae-email-color" href="mailto:mathieu@affinity-engine.fr">mathieu@affinity-engine.fr</a></li>
			<li>{l s='The commercial service at' mod='affinityitems'} <span class="ae-email-color">+33 9 80 47 24 83</span></li>
		</ul>
		{l s='DOCUMENTATION - If you have any questions do not hesitate to consult : ' mod='affinityitems'}
		<ul>	
			{if $lang=="fr"}
			<li><a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/fr-home">{l s='documentation' mod='affinityitems'}</a></li>
			<li><a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/fr-page-faq">{l s='FAQ' mod='affinityitems'}</a></li>
			<li><a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/fr-page-installation">{l s='installation guide' mod='affinityitems'}</a></li>
			{else}
			<li><a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/en-home">{l s='documentation' mod='affinityitems'}</a></li>
			<li><a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/en-page-installation">{l s='installation guide' mod='affinityitems'}</a></li>
			{/if}
		</ul>
	</div>
	<div class="items-alert" style="display:none;"></div>
	<div class="items-content">
		<div class="items-auth-zone">
			<div class="items-auth-container items-left">
				<form class="items-login-container">
					<h3>{l s='Login in' mod='affinityitems'}</h3>
					<br>
					<input type="text" class="aeinput" id="lemail" value="{$employee[0].email|escape:'htmlall':'UTF-8'}" placeholder="{l s='Email' mod='affinityitems'}" />
					<br>
					<input type="password" class="aeinput" id="lpassword" placeholder="{l s='Password' mod='affinityitems'}" />
					<br>
					<input id="aelogin" class="items-auth-button" type="submit" value="{l s='Login' mod='affinityitems'}" />
					<br>
					{l s='Don\'t have an account ?' mod='affinityitems'}
					<input class="items-auth-switch" type="submit" value="{l s='Register an account' mod='affinityitems'}" />
				</form>

				<form class="items-register-container">
					<h3>{l s='Register an account' mod='affinityitems'}</h3>					
					<input type="text" class="aeinput" id="rfirstname" value="{$employee[0].firstname|escape:'htmlall':'UTF-8'}" placeholder="{l s='Firstname' mod='affinityitems'}" />
					<br>
					<input type="text" class="aeinput" id="rlastname" value="{$employee[0].lastname|escape:'htmlall':'UTF-8'}" placeholder="{l s='Lastname' mod='affinityitems'}" />
					<br>	 
					<input type="text" class="aeinput" id="remail" value="{$employee[0].email|escape:'htmlall':'UTF-8'}" placeholder="{l s='Email' mod='affinityitems'}" />
					<br>
					<input type="password" class="aeinput" id="rpassword" placeholder="{l s='Password' mod='affinityitems'}" />
					<br>
					<input type="password" class="aeinput" id="rconfirmPassword" placeholder="{l s='Confirm your password' mod='affinityitems'}" />
					<br>
					<input type="text" class="aeinput" id="rdiscount" placeholder="{l s='Discount code' mod='affinityitems'}" />
					<br>
					<select name="ractivity" id="ractivity">
						<option value="0" {if $activity == 0} selected {/if}>{l s='Activity' mod='affinityitems'}</option>
						<option value="1" {if $activity == 1} selected {/if}>{l s='Adult' mod='affinityitems'}</option>
						<option value="2" {if $activity == 2} selected {/if}>{l s='Animals and Pets' mod='affinityitems'}</option>
						<option value="3" {if $activity == 3} selected {/if}>{l s='Art and Culture' mod='affinityitems'}</option>
						<option value="4" {if $activity == 4} selected {/if}>{l s='Babies' mod='affinityitems'}</option>
						<option value="5" {if $activity == 5} selected {/if}>{l s='Beauty and Personal Care' mod='affinityitems'}</option>
						<option value="6" {if $activity == 6} selected {/if}>{l s='Cars' mod='affinityitems'}</option>
						<option value="7" {if $activity == 7} selected {/if}>{l s='Computer Hardware and Software' mod='affinityitems'}</option>
						<option value="8" {if $activity == 8} selected {/if}>{l s='Download' mod='affinityitems'}</option>
						<option value="9" {if $activity == 9} selected {/if}>{l s='Flowers, Gifts and Crafts' mod='affinityitems'}</option>
						<option value="10" {if $activity == 10} selected {/if}>{l s='Fleurs et cadeaux' mod='affinityitems'}</option>
						<option value="11" {if $activity == 11} selected {/if}>{l s='Food and beverage' mod='affinityitems'}</option>
						<option value="12" {if $activity == 12} selected {/if}>{l s='HiFi, Photo and Video' mod='affinityitems'}</option>
						<option value="13" {if $activity == 13} selected {/if}>{l s='Home and Garden' mod='affinityitems'}</option>
						<option value="14" {if $activity == 14} selected {/if}>{l s='Home Appliances' mod='affinityitems'}</option>
						<option value="15" {if $activity == 15} selected {/if}>{l s='Jewelry' mod='affinityitems'}</option>
						<option value="16" {if $activity == 16} selected {/if}>{l s='Mobile and Telecom' mod='affinityitems'}</option>
						<option value="17" {if $activity == 17} selected {/if}>{l s='Services' mod='affinityitems'}</option>
						<option value="18" {if $activity == 18} selected {/if}>{l s='Shoes and accessories' mod='affinityitems'}</option>
						<option value="19" {if $activity == 19} selected {/if}>{l s='Sport and Entertainment' mod='affinityitems'}</option>
						<option value="20" {if $activity == 20} selected {/if}>{l s='Travel' mod='affinityitems'}</option>
					</select>
					<br>
					<p class="ae-cgv"><input type="checkbox" id="rcgv">
						{l s='I accept the' mod='affinityitems'} <a target='_blank' href="{$module_dir|escape:'htmlall':'UTF-8'}resources/pdf/contract.pdf" >{l s='terms and conditions of use.' mod='affinityitems'}</a> {l s='and I have read the Affinity Engine confidentiality policy.' mod='affinityitems'}
					</p>
					<input id="aeregister" class="items-auth-button" type="submit" value="{l s='Register' mod='affinityitems'}" />
					<br>
					<input class="items-auth-switch" type="submit" value="{l s='You already have an account' mod='affinityitems'} ?" />
				</form>
				<div class="clear"></div>
			</div>
			<div class="items-auth-presentation items-right">
				<div class='ae-auth-desc aecontent'>
					<div class="items-auth-presentation-block">
					<h3>{l s='An unrivalled service level thanks to real-time semantic' mod='affinityitems'}</h3>
					<img src="{$module_dir|escape:'htmlall':'UTF-8'}img/aeboard.jpg">
					<ul>
						<li>{l s='Precise understanding of each visitor tastes and needs' mod='affinityitems'}</li>
						<li>{l s='Taylor-made recommendations for each visitor' mod='affinityitems'}</li>
						<li>{l s='Recommendations as soon as the very first visit' mod='affinityitems'}</li>
					</ul>
					</div>
					<div class="clear"></div>
					<div class="items-auth-presentation-block items-auth-presentation-block-middle">
					<h3>{l s='A flexible set-up' mod='affinityitems'}</h3>
					<img src="{$module_dir|escape:'htmlall':'UTF-8'}img/aestart.jpg">
					<ul>
						<li>{l s='Chose the recommendations role: cross-selling, up-selling…' mod='affinityitems'}</li>
						<li>{l s='Chose the recommendations product perimeter (eg promotions, new articles, specific catégories…) ' mod='affinityitems'}</li>
						<li>{l s='A perfect match with your website design.' mod='affinityitems'}</li>
						<li>{l s='Total and instant control on recommendations areas activation.' mod='affinityitems'}</li>
					</ul>
					</div>
					<div class="clear"></div>
					<div class="items-auth-presentation-block">
					<h3>{l s='A highly-profitable service, from 20 £/month' mod='affinityitems'}</h3>
					<img src="{$module_dir|escape:'htmlall':'UTF-8'}img/aemoney.jpg">
					<ul>
						<li>{l s='A pay-per-use cost, adapted to your stakes (minimum monthly billing: 20£/month, be around 18 000 recommendations)' mod='affinityitems'}</li>
						<li>{l s='A cost cost is largely covered by the additional margin generated. ' mod='affinityitems'} <a class="ae-link-color" href="http://www.affinity-engine.fr/simulateur-de-rentabilite">{l s='Simulate service profitability for your website' mod='affinityitems'}</a></li>
						<li>{l s='No commitment on contract length.' mod='affinityitems'}</li>
					</ul>
					</div>
					<div class="clear"></div>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="clear"></div>
	</div>

</div>