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
			<strong>{l s='Improve your sales by up to 50%' mod='affinityitems'} <br> {l s='thanks to personalized recommendations.' mod='affinityitems'}</strong><br><br>
			<p>{l s='Give each visitor the products that fit his tastes' mod='affinityitems'}</p>
			<p>{l s='& needs and benefit from higher transformation rate' mod='affinityitems'}</p>
			<p>{l s='average basket and visitors loyalty.' mod='affinityitems'}</p><br />
			<p>{l s='Easy to install, this service has no fixed costs, requires no commitment, and drives a big bunch of profits.' mod='affinityitems'}</p><br>
			<strong>{l s='And a free trial offer for 1 month.' mod='affinityitems'}</strong><br><br>
			<p>{l s='Take no risks try and see !' mod='affinityitems'}</p>
		</div>
		<div class="items-explain-image">
			<object type="text/html" data="http://www.youtube.com/embed/rxn3fHYNL3s" width="400" height="236"></object>
		</div>
	</div>
	<div class="clear"></div>
	<div class="ae-info-auth"> 
		{l s='If you have any problems with your Affinity Items module, please access to the ' mod='affinityitems'} 
		{if $lang=="fr"}
		<a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/fr-home">{l s='documentation' mod='affinityitems'}</a>
		/ <a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/fr-page-faq">{l s='FAQ' mod='affinityitems'}</a>
		/ <a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/fr-page-installation">{l s='installation guide' mod='affinityitems'}</a>
		{else}
		<a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/en-home">{l s='documentation' mod='affinityitems'}</a>
		/ <a class="ae-email-color" target="_blank" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/en-page-installation">{l s='installation guide' mod='affinityitems'}</a>
		{/if}
		<br />
		{l s='We can install and configure the Affinity Items module for your website at no extra cost' mod='affinityitems'}
		<br>
		{l s='Do not hesitate to contact us for any questions :' mod='affinityitems'}
		<ul>
			<li>{l s='The technical support at' mod='affinityitems'} <span class="ae-email-color">+33 9 54 52 85 12</span> {l s='or contact' mod='affinityitems'} <a class="ae-email-color" href="mailto:mathieu@affinity-engine.fr">mathieu@affinity-engine.fr</a></li>
			<li>{l s='The commercial service at' mod='affinityitems'} <span class="ae-email-color">+33 9 80 47 24 83</span></li>
		</ul>
	</div>
	<div class="items-alert" style="display:none;"></div>
	<div class="items-content">
		<div class="items-auth-zone">
			<div class="items-auth-container items-left">
				<form class="items-login-container">
					<h3>{l s='Login in' mod='affinityitems'}</h3>
					<br>
					<input type="text" class="aeinput" id="lemail" value="{$employee[0].email}" placeholder="{l s='Email' mod='affinityitems'}" />
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
					<input type="text" class="aeinput" id="rfirstname" value="{$employee[0].firstname}" placeholder="{l s='Firstname' mod='affinityitems'}" />
					<br>
					<input type="text" class="aeinput" id="rlastname" value="{$employee[0].lastname}" placeholder="{l s='Lastname' mod='affinityitems'}" />
					<br>	 
					<input type="text" class="aeinput" id="remail" value="{$employee[0].email}" placeholder="{l s='Email' mod='affinityitems'}" />
					<br>
					<input type="password" class="aeinput" id="rpassword" placeholder="{l s='Password' mod='affinityitems'}" />
					<br>
					<input type="password" class="aeinput" id="rconfirmPassword" placeholder="{l s='Confirm your password' mod='affinityitems'}" />
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
					<input class="items-auth-switch" type="submit" value="{l s='Login in' mod='affinityitems'}" />

				</form>

				<div class="clear"></div>

			</div>

			<div class="items-auth-presentation items-right">
				<div class='ae-auth-desc aecontent'>
					<div class="items-auth-presentation-block">
					<h3>{l s='Unmatched performance through real-time semantics' mod='affinityitems'}</h3>
					<img src="{$module_dir|escape:'htmlall':'UTF-8'}resources/img/aeboard.jpg">
					<ul>
						<li>{l s='Detailed understanding of the needs and expectations of visitors by giving meaning to their actions' mod='affinityitems'}</li>
						<li>{l s='Recommendations tailored to each visitor' mod='affinityitems'}</li>
						<li>{l s='Recommendations from the very first visit' mod='affinityitems'}</li>
					</ul>
					</div>
					<div class="clear"></div>
					<div class="items-auth-presentation-block">
					<h3>{l s='A solution easy to install and to configure' mod='affinityitems'}</h3>
					<img src="{$module_dir|escape:'htmlall':'UTF-8'}resources/img/aestart.jpg">
					<ul>
						<li>{l s='Fully automatic installation' mod='affinityitems'}</li>
						<li>{l s='Simple and flexible settings (10-15 minutes) for seamless integration into your site' mod='affinityitems'}</li>
						<li>{l s='Total control over the activation areas and abtesting' mod='affinityitems'}</li>
					</ul>
					</div>
					<div class="clear"></div>
					<div class="items-auth-presentation-block">
					<h3>{l s='A very profitable, without commitment, and accessible to all department sites, large or small' mod='affinityitems'}</h3>
					<img src="{$module_dir|escape:'htmlall':'UTF-8'}resources/img/aemoney.jpg">
					<ul>
						<li>{l s='No setup costs, no monthly fixed cost' mod='affinityitems'}</li>
						<li>{l s='Pay per use only, at a cost widely covered by the additional margin generated.' mod='affinityitems'} <a class="ae-link-color" href="http://www.affinity-engine.fr/simulateur-de-rentabilite">{l s='Simulate cost and profitability of service for your website' mod='affinityitems'}</a></li>
						<li>{l s='No minimum volume, nor duration commitment' mod='affinityitems'}</li>
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