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
			$('#rdiscount').hide();
			$('.items-register-container').on('submit', function() {
				r = [];
				if (!v.test($("#remail").val())) {
					r[r.length] = "{/literal}{l s='Please enter a valid email address' mod='affinityitems'}{literal}";
				}
				if (!n.test($("#rpassword").val())) {
					r[r.length] = "{/literal}{l s='You password must be between 6 and 20 characters long.' mod='affinityitems'}{literal}";
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
							email: $("#remail").val(),
							password: $("#rpassword").val(),
							discountCode: $("#rdiscount").val(),
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
});
{/literal}
</script>
<div class="items-wrapper">
	
	<div class="items-header">
		<div class="aelogo"></div>
	</div>
	<div class="items-alert" style="display:none;"></div>
	<div class="items-content">
		<div class="items-auth-zone">
			<div class="items-auth-container items-left">

				<div class="items-auth-register">

					<h3>{l s='Sign up for 30-days free trial' mod='affinityitems'}</h3>
					<p>{l s='To get a clear view of the impact on your sales ' mod='affinityitems'}</p>
					<p>{l s='at the end of the trial' mod='affinityitems'}</p>
					<form class="items-register-container">
						<input type="text" class="aeinput" id="remail" value="{$employee[0].email|escape:'htmlall':'UTF-8'}" placeholder="{l s='Email' mod='affinityitems'}" />
						<br>
						<input type="password" class="aeinput" id="rpassword" placeholder="{l s='Password' mod='affinityitems'}" />
						<br>
						<a href="#" onClick="$(this).hide(); $('#rdiscount').show(); $('#aeregister').css('margin-top', '48px'); return false;" class="items-text-discount-code">{l s='I\'ve got a discount code' mod='affinityitems'}</a>
						<input type="text" class="aeinput" id="rdiscount" placeholder="{l s='Discount code' mod='affinityitems'}" />

						<div class="ae-cgv">
							<input type="checkbox" id="rcgv">
							{l s='I accept the' mod='affinityitems'} <a target='_blank' href="{$module_dir|escape:'htmlall':'UTF-8'}resources/pdf/contract.pdf" >{l s='terms and conditions of use.' mod='affinityitems'}</a>
						</div>
						<input id="aeregister" class="items-button items-green" type="submit" value="{l s='Install affinity items' mod='affinityitems'}" />
					</form>

				</div>

			</div>
			
			<div class="items-auth-presentation items-right">
				
				<div class="items-auth-presentation-content">
					<h3>{l s='Boost your transformation rate' mod='affinityitems'}</h3>
					<p>{l s='Suggest automatically, on each page,' mod='affinityitems'}</p>
					<p>{l s='a selection of products that match each visitor needs.' mod='affinityitems'}</p>
					<div class="items-video">
						<span class="items-video-promotion"><object type="text/html" data="http://www.youtube.com/embed/rxn3fHYNL3s" width="340" height="210"></object></span>
					</div>
					<p>{l s='Up to 60' mod='affinityitems'}% {l s='of products sold' mod='affinityitems'}</p>
					<p>{l s='have been recommended by affinity items.' mod='affinityitems'}</p>
					<a class="items-button items-purple" href="http://addons.prestashop.com/fr/ventes-croisees-cross-selling/17491-affinityitems.html">{l s='More about' mod='affinityitems'}</a>
				</div>

			</div>
			
			<div class="clear"></div>

		</div>
	</div>

</div>