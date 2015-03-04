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

	<script>
	{literal}
	function synchronize() {
		$.ajax({
			{/literal}{if $ajaxController}{literal}
			url: "index.php?controller=AEAjax&configure=affinityitems&ajax",
			{/literal}{else}{literal}
			url: "{/literal}{$module_dir|escape:'htmlall':'UTF-8'}{literal}ajax/synchronize.php",
			{/literal}{/if}{literal}
			data: {"synchronize" : true, "getInformation" : true, "token" : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}"},
			type: "POST",
			async: true,
			success: function (e, t, n) {
				var response = jQuery.parseJSON(e);
				if(response._ok == true) {
					if(response._activate == 1) {
						if(response._percentage == 100) {
							$('.items-synchronize-container').css('background-color', '#82c836');
							$('.items-synchronize-container').css('color', 'white');
							$('.items-synchronize-container').html($('#items-synchronize-finished').html());
						} else {
							$('.items-synchronize-container').css('background-color', '#82c836');
							$('.items-synchronize-container').css('color', 'white');
							$('.items-synchronize-container').html($('#items-synchronize-in-progress').html());
						}
					} else {
						$('.items-synchronize-container').css('background-color', '#f2f2f2');
						$('.items-synchronize-container').css('color', 'grey');
						$('.items-synchronize-container').html($('#items-synchronize-desactivate').html());
					}
				}
			}});
setTimeout("synchronize()", 10000);
}

function hideMessage() {
	$(".items-success").hide();
	$(".items-success").empty();
	$(".items-alert").hide();
	$(".items-alert").empty();
}

function success(e) {
	hideMessage();
	var t = "{/literal}{l s='Operation successfully completed' mod='affinityitems'}{literal}";
	$(".items-success").append(t);
	$(".items-success").slideDown();
}

function error(e) {
	hideMessage()
	var t = "{/literal}{l s='Please enter valid data' mod='affinityitems'}{literal} : <br>";
	for (var n = 0; n < e.length; n++) {
		var r = n + 1;
		t += "\n" + r + ". " + e[n] + "<br>";
	}
	$(".items-alert").append(t);
	$(".items-alert").slideDown();
}

function overlay() {
	var overlay = document.getElementById("items-overlay");
	var content = document.getElementById("items-overlay-content");
	overlay.style.visibility = (overlay.style.visibility == "visible") ? "hidden" : "visible";
	content.style.visibility = (content.style.visibility == "visible") ? "hidden" : "visible";
}

function showPreview(img) {
	var overlay = document.getElementById("items-preview-overlay");
	var content = document.getElementById("items-preview-overlay-content-"+img.toLowerCase());
	overlay.style.visibility = (overlay.style.visibility == "visible") ? "hidden" : "visible";
	content.style.visibility = (content.style.visibility == "visible") ? "hidden" : "visible";
}

function closeFunnel() {
	$.ajax({
		{/literal}{if $ajaxController}{literal}
		url: "index.php?controller=AEAjax&configure=affinityitems&ajax",
		{/literal}{else}{literal}
		url: "{/literal}{$module_dir|escape:'htmlall':'UTF-8'}{literal}ajax/funnel.php",
		{/literal}{/if}{literal}
		data: {"closeFunnel" : true, "token" : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}"},
		type: "POST",
		async: true,
		success: function (e, t, n) {
			var response = jQuery.parseJSON(e);
			if(response._ok == true) {
				var url = document.location.href.match(/(^[^#]*)/)[0];
				window.location=url+"#activation";
				location.reload();
			}
		}});
}

function showPage(name) {
	window.location.hash = '#' + name;
	$.each(pages, function(index, value) {
		var content = $('#items-' + value);
		if(name === value) {
			content.show();
		} else {
			content.hide();
		}
	});
	$('.items-menu').hide();
	hideMessage();
}

function switchSupportTab(name) {
	if(name == 'logs') {
		$('#items-tab-wiki').hide();
		$('#items-tab-log').show();
		$('.items-faq-tab').removeClass('items-tab-active');
		$('.items-logs-tab').addClass('items-tab-active');
	} else {
		$('#items-tab-log').hide();
		$('#items-tab-wiki').show();
		$('.items-faq-tab').addClass('items-tab-active');
		$('.items-logs-tab').removeClass('items-tab-active');
	}
}

var pages = ['funnel-step-one', 'funnel-step-two', 'dashboard', 'activation', 'config', 'theme-editor', 'support', 'help', 'desactivate'];

$(document).ready(function() {
	synchronize();
	{/literal}{if !$isConfig}$('.items-icon-menu').hide();{/if}{literal}
	$('.items-menu').hide();
	$('#items-tab-log').hide();
	$("#items-wiki").load("http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/v1.1/fr-page-faq .wiki-holder", function(response, status, xhr) {
		var html = $("#items-wiki").html();
		var result = html.replace(/<a href="/g, '<a target="_blank" class="ae-email-color" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/');
		$("#items-wiki").html(result);
	});

	$('.items-icon-menu').on('click', function() {
		if($('.items-menu').is(':visible')) {
			$('.items-menu').hide();
		} else {
			$('.items-menu').show();
		}
	});

	$('#registerTheme').click(function() {
		overlay();
		return false;
	});

	$('#items-overlay').click(function() {
		overlay();
	});


	$('#items-preview-overlay').click(function() {
		var overlay = document.getElementById("items-preview-overlay");
		var bright = document.getElementById("items-preview-overlay-content-bright");
		var dark = document.getElementById("items-preview-overlay-content-dark");
		overlay.style.visibility = "hidden";
		bright.style.visibility = "hidden";
		dark.style.visibility = "hidden";
	});

	$('.ae-type-recommendation-select').on("change", function() {
		if($(this).val() == "recoAllFiltered") {
			$(this).closest('table').next('.items-reco-all-filtered').fadeIn();
		} else {
			$(this).closest('table').next('.items-reco-all-filtered').fadeOut();
		}
	});

	$('.items-open-theme-list').on("click", function() {
		if(!$(this).closest('table').next().next().is(':visible')) {
			$(this).closest('table').next().next().fadeIn();
		} else {
			$(this).closest('table').next().next().fadeOut();
		}
		return false;
	});

	var hash = window.location.hash.substring(1);
	if(hash) {
		showPage(hash);
	} else {
		showPage({/literal}{if $isConfig}'dashboard'{else}'funnel-step-one'{/if}{literal});
	}

	$('#themeSelector').on('change', function() {
		var url = location.search;
		var regex = /id_theme=[0-9]*/i;
		var redirect = url;
		if(regex.exec(url)) {
			redirect = url.replace(regex, 'id_theme='+$('#themeSelector').val());
		} else {
			redirect = url+"&id_theme="+$('#themeSelector').val();
		}
		document.location.href = redirect+'#theme-editor';
	});

	var toolbox = 'default';
	$('.toolbox-button').click(function() {
		$('.' + toolbox + '-toolbox').hide();
		toolbox = $(this).attr('toolbox');
		$('.' + toolbox + '-toolbox').show();
	});

	$('.items-eye').on('click', function() {
		$.ajax({
			{/literal}{if $ajaxController}{literal}
			url: "index.php?controller=AEAjax&configure=affinityitems&ajax",
			{/literal}{else}{literal}
			url: "{/literal}{$module_dir|escape:'htmlall':'UTF-8'}{literal}ajax/preview.php",
			{/literal}{/if}{literal}
			type: "POST",
			data : {'preview' : 'true', "token" : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}", "aetoken" : '{/literal}{$aetoken}{literal}'},
			async: false,
			success: function (e, t, n) {
				var response = jQuery.parseJSON(e);
				if(response._ok == true) {
					window.open("{/literal}{$baseUrl|escape:'htmlall':'UTF-8'}{literal}",'_blank');
				}
			}
		});
	});

	$('.items-help-button').on('click', function() {
		var reg = new RegExp("^0[1-9]([-. ]?[0-9]{2}){4}$");
		var firstname = $('#items-help-firstname').val();
		var lastname = $('#items-help-lastname').val();
		var phone = $('#items-help-phone').val();
		r = [];
		
		if(firstname == '' || lastname == '' || phone == '') {
			r[r.length] = "{/literal}{l s='Please enter a lastname, firstname and phone' mod='affinityitems'}{literal}";
			error(r);
			return;
		}

		if(!reg.test(phone)){
			r[r.length] = "{/literal}{l s='Please enter a valid phone' mod='affinityitems'}{literal}";
			error(r);
			return;
		}

		$.ajax({
			{/literal}{if $ajaxController}{literal}
			url: "index.php?controller=AEAjax&configure=affinityitems&ajax",
			{/literal}{else}{literal}
			url: "{/literal}{$module_dir|escape:'htmlall':'UTF-8'}{literal}ajax/support.php",
			{/literal}{/if}{literal}
			type: "POST",
			data : {
				"support" : true,
				"help" : true,
				"firstname" : firstname,
				"lastname" : lastname,
				"phone" : phone,
				"token" : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}", 
				"aetoken" : '{/literal}{$aetoken}{literal}'
			},
			async: false,
			success: function (e, t, n) {
				success();
			}
		});
	});


$('.items-desactivate-button').on('click', function() {
	$.ajax({
		{/literal}{if $ajaxController}{literal}
		url: "index.php?controller=AEAjax&configure=affinityitems&ajax",
		{/literal}{else}{literal}
		url: "{/literal}{$module_dir|escape:'htmlall':'UTF-8'}{literal}ajax/support.php",
		{/literal}{/if}{literal}
		type: "POST",
		data : {
			"support" : true,
			"desactivate" : true,
			"reason" : $(".items-desactivate-reason:checked").val(),
			"token" : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}", 
			"aetoken" : '{/literal}{$aetoken}{literal}'
		},
		async: false,
		success: function (e, t, n) {
			success();
			showPage('dashboard');
		}
	});
});

$("#myonoffswitch").on('change', function(){
	var checked = $(this).is(':checked') ? 1 : 0;
	$.ajax({
		{/literal}{if $ajaxController}{literal}
		url: "index.php?controller=AEAjax&configure=affinityitems&ajax",
		{/literal}{else}{literal}
		url: "{/literal}{$module_dir|escape:'htmlall':'UTF-8'}{literal}ajax/property.php",
		{/literal}{/if}{literal}
		type: "POST",
		data : {"activation" : checked, "token" : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}", "aetoken" : '{/literal}{$aetoken}{literal}'},
		async: false,
		success: function (e, t, n) {
			if(!checked) {
				showPage('desactivate');
			}
		}
	});
});

$('.items-reco-all-filtered-select').on("change", function() {
	if($(this).val() == "byCategory") {
		$(this).closest('.items-reco-all-filtered').find(".categoryIds").show();
		$(this).closest('.items-reco-all-filtered').find(".attributeIds").hide();
		$(this).closest('.items-reco-all-filtered').find(".featureIds").hide();
	} else if($(this).val() == "byAttribute") {
		$(this).closest('.items-reco-all-filtered').find(".categoryIds").hide();
		$(this).closest('.items-reco-all-filtered').find(".attributeIds").show();
		$(this).closest('.items-reco-all-filtered').find(".featureIds").hide();
	} else if($(this).val() == "byFeature") {
		$(this).closest('.items-reco-all-filtered').find(".categoryIds").hide();
		$(this).closest('.items-reco-all-filtered').find(".attributeIds").hide();
		$(this).closest('.items-reco-all-filtered').find(".featureIds").show();
	} else {
		$(this).closest('.items-reco-all-filtered').find(".categoryIds").hide();
		$(this).closest('.items-reco-all-filtered').find(".attributeIds").hide();
		$(this).closest('.items-reco-all-filtered').find(".featureIds").hide();
	}
});
{/literal}{include file="./live-editor.tpl"}{literal}
});
{/literal}
</script>
<div id="items-preview-overlay"></div>
<div id="items-preview-overlay-content-bright" class="items-preview-overlay-content">
	<img src='{$module_dir|escape:'htmlall':'UTF-8'}img/bright.png' alt='bright' />
</div>
<div id="items-preview-overlay-content-dark" class="items-preview-overlay-content">
	<img src='{$module_dir|escape:'htmlall':'UTF-8'}img/dark.png' alt='dark' />
</div>
<div class="items-wrapper">
	<div class="items-header">
		<div class="aelogo" onclick="showPage({if $isConfig}'dashboard'{else}'funnel-step-one'{/if}); return false;"></div>
		<div class="items-icon-menu"></div>
		
		<div class="items-menu-help items-button items-right">
			<a href="#" onClick="showPage('help'); return false;">{l s='Help' mod='affinityitems'}</a>
		</div>

		<div class="items-menu">
			<div class="items-icon-top-menu"></div>
			<ul>
				<li><a href="#" onClick="showPage('dashboard'); return false;">{l s='Home' mod='affinityitems'}</a></li>
				<li><a href="#" onClick="showPage('activation'); return false;">{l s='Settings' mod='affinityitems'}</a></li>
				{if isset($data->authToken)}
				<li><a target="_blank" href="http://manager.affinityitems.com/login/{$siteId|escape:'htmlall':'UTF-8'}/{$data->authToken|escape:'htmlall':'UTF-8'}">{l s='Account' mod='affinityitems'}</a></li>
				{/if}
				<li><a href="#" onClick="showPage('support'); return false;">{l s='Support' mod='affinityitems'}</a></li>
			</ul>
		</div>
	</div>

	<div class="items-alert" style="display:none;"></div>
	<div class="items-success" style="display:none;"></div>

	<div id="items-dashboard">

		<p> > {l s='Dashboard' mod='affinityitems'} </p>

		<div class="items-synchronize-container"></div>
		
		<div class="items-boxes">

			<div class="items-box items-box-black items-box-first">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->onlineUsers)}{$statistics->onlineUsers}{else}0{/if} </span> <br /> <span class="items-box-text">{l s='current connected' mod='affinityitems'}<br />{l s='visitors' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-black">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->cartsInProgress)}{$statistics->cartsInProgress}{else}0{/if}</span> <br /> <span class="items-box-text">{l s='current' mod='affinityitems'}<br />{l s='carts' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-purple">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->lastMonthVisitsWithRecommendation)}{$statistics->lastMonthVisitsWithRecommendation}{else}0{/if}</span> <br /> <span class="items-box-text">{l s='visits with' mod='affinityitems'}<br />{l s='recommendations' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-purple">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->bestClickRate->rate)} {math equation="rate * cent" cent=100 rate={$statistics->bestClickRate->rate} format="%.1f"} %{else}0{/if}</span> <br /> <span class="items-box-text"> {l s='recommendations click rate on' mod='affinityitems'} {if $statistics && $statistics->bestClickRate->hook}{$statistics->bestClickRate->hook}{/if} {l s='page*' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-purple">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->lastMonthClickersConversationRate)}{math equation="lastMonthClickersConversationRate * cent" cent=100 lastMonthClickersConversationRate={$statistics->lastMonthClickersConversationRate} format="%.1f"} %{else}0{/if}</span> <br /> <span class="items-box-text">{l s='transformation rate among clickers *' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-black items-box-first">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->lastMonthOrders)}{$statistics->lastMonthOrders}{else}0{/if}</span> <br /> <span class="items-box-text">{l s='orders last'  mod='affinityitems'}<br />{l s='30 days' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-black">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->lastMonthSales)}{$statistics->lastMonthSales|string_format:"%.0f"}{else}0{/if}</span> <br /> <span class="items-box-text">{l s='sales last' mod='affinityitems'}<br />{l s='30 days' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-purple">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($data->recommendation)}{$data->recommendation}{else}0{/if}</span> <br /> <span class="items-box-text">{l s='recommandations' mod='affinityitems'}<br />{l s='since 30 days' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-purple">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->salesAfterClick)}{$statistics->salesAfterClick|string_format:"%.0f"}{else}0{/if} €</span> <br /> <span class="items-box-text">{l s='of sales following click on recommendations*' mod='affinityitems'}</span></p>
			</div>

			<div class="items-box items-box-purple">
				<p><span class="items-box-large-font">{if $statistics && is_numeric($statistics->salesAfterReco)}{$statistics->salesAfterReco|string_format:"%.0f"}{else}0{/if} €</span> <br /> <span  class="items-box-text">{l s='of sales following' mod='affinityitems'}<br />{l s='a recommendation*' mod='affinityitems'}</span></p>
			</div>

		</div>

		<div class="clear"></div>
	</div>

	<div id="items-activation">

		<p> > {l s='Settings' mod='affinityitems'} </p>

		<div class="items-activation-container">

			<div class="onoffswitch">
				<input type="checkbox" name="onoffswitch" class="onoffswitch-checkbox" id="myonoffswitch" {if $recommendation==1} checked {/if}>
				<label class="onoffswitch-label" for="myonoffswitch">
					<span class="onoffswitch-inner"></span>
					<span class="onoffswitch-switch"></span>
				</label>
			</div>

			<h2>{l s='Recommendation activation' mod='affinityitems'}</h2>
			<span class="items-activation-text">{l s='Note : during the free-trial period, only 50' mod='affinityitems'}% {l s='of visitors get recommandations.' mod='affinityitems'}</span>

			<i class="fa fa-eye items-right items-eye"><span class="items-eye-text">{l s='preview' mod='affinityitems'}</span></i>

		</div>

		<div class="clear"></div>

		<div class="items-activation-content">
			<div class="items-activation-content-settings">
				<a href="#" onClick="showPage('config'); return false;"> <div class="items-activation-button items-purple">  {l s='Parameters' mod='affinityitems'} </div> </a>
				<div class="items-activation-content-settings-text">
					<div class="items-activation-content-settings-text-container">
						{l s='Define the recommendation zones' mod='affinityitems'}
						<br />
						{l s='per page : role, theme...' mod='affinityitems'}
					</div>
				</div>
				<div class="clear"></div>
			</div>

			<br />

			<div class="items-activation-content-settings">
				<a href="#" onClick="showPage('theme-editor'); return false;"> <div class="items-activation-button items-purple"> {l s='Design' mod='affinityitems'} </div> </a>
				<div class="items-activation-content-settings-text">
					<div class="items-activation-content-settings-text-container">
						{l s='Simply create or manage graphic themes' mod='affinityitems'}
						<br />
						{l s='available for recommendation zones' mod='affinityitems'}
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div>
	</div>

	<div id="items-config">

		<p> > {l s='Settings' mod='affinityitems'} > {l s='Parameters' mod='affinityitems'} </p>

		<div class="zone-config">
			<form action='#config' method='POST'/>

			<div class="items-config-container">

				<div class="items-config-text">
					{l s='Define recommendations wished on each page type.' mod='affinityitems'}
					<br />
					{l s='Use existing graphic themes. (go to setup > design to create or modify availablle themes.)' mod='affinityitems'}
				</div>

				<input type="submit" value="{l s='Save' mod='affinityitems'}" class="items-button items-green items-button-config-container">
			</div>

			<div class="clear"></div>

			<input type="hidden" name="configZoneReco" value="1">

			{foreach from=$hookList item=hook}
			{assign var="zone1" value="{$hook}_1"}
			{assign var="zone2" value="{$hook}_2"}

			<div class="zone" id="zone-{$hook|lower}">
				<span class="title">
					{$hook|escape:'htmlall':'UTF-8'}  (2 zones {l s='available' mod='affinityitems'})
				</span>
				<div>
					<table style="width:100%">
						<tr>
							<th class="items-table-activation-cell">{l s='Activation' mod='affinityitems'}</th>
							<th class="items-table-zone-title-cell">{l s='Zone title' mod='affinityitems'}</th> 
							<th class="items-table-recommendation-type-cell">{l s='Recommendation type' mod='affinityitems'}</th>
							<th class="items-table-product-number-cell">{l s='Product number' mod='affinityitems'}</th>
							<th class="items-table-theme-cell">{l s='Theme' mod='affinityitems'}</th>
						</tr>
					</table>

					<table style="width:100%">
						<tr>
							<td>						
								<div class="onoffswitch">
									<input type="hidden" name="reco{$hook|escape:'htmlall':'UTF-8'}_1" value="0">
									<input type="checkbox" name="reco{$hook|escape:'htmlall':'UTF-8'}_1" class="onoffswitch-checkbox" id="reco{$hook|escape:'htmlall':'UTF-8'}_1" value="1" {if $configuration.{$hook}->reco{$zone1} == "1"} checked {/if}>
									<label class="onoffswitch-label" for="reco{$hook|escape:'htmlall':'UTF-8'}_1">
										<span class="onoffswitch-inner"></span>
										<span class="onoffswitch-switch"></span>
									</label>
								</div>
							</td>
							<td>
								<input class="items-selectors-input" name="recoTitle{$hook|escape:'htmlall':'UTF-8'}_1" type="text" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoTitle{$zone1}}">
							</td>
							<td>
								<select class="ae-type-recommendation-select" name="recoType{$hook|escape:'htmlall':'UTF-8'}_1">
									{if {$hook|lower} == "home" || {$hook|lower} == "left" || {$hook|lower} == "right"}
									<option {if $configuration.{$hook}->recoType{$zone1} == "recoAll"} selected {/if} value="recoAll">{l s='Personalized recommendation' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoType{$zone1} == "recoAllFiltered"} selected {/if} value="recoAllFiltered">{l s='Filtered personalized recommendation' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoType{$zone1} == "recoLastSeen"} selected {/if} value="recoLastSeen">{l s='Last liked products' mod='affinityitems'}</option>
									{else if {$hook|lower} == "cart"}
									<option value="recoCart">{l s='Personalized recommendation' mod='affinityitems'}</option>
									{else if {$hook|lower} == "product"}
									<option {if $configuration.{$hook}->recoType{$zone1} == "recoSimilar"} selected {/if} value="recoSimilar">{l s='Personalized recommendation' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoType{$zone1} == "recoUpSell"} selected {/if} value="recoUpSell">{l s='Up selling' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoType{$zone1} == "recoCrossSell"} selected {/if} value="recoCrossSell">{l s='Cross selling' mod='affinityitems'}</option>
									{else if {$hook|lower} == "category"}
									<option {if $configuration.{$hook}->recoType{$zone1} == "recoCategory"} selected {/if} value="recoCategory">{l s='Personalized recommendation' mod='affinityitems'}</option>
									{else if {$hook|lower} == "search"}
									<option {if $configuration.{$hook}->recoType{$zone1} == "recoSearch"} selected {/if} value="recoSearch">{l s='Personalized recommendation' mod='affinityitems'}</option>
									{/if}
								</select>
							</td>
							<td>
								<input class="ae-number-reco-input" type="number" min="1" max="20" name="recoSize{$hook|escape:'htmlall':'UTF-8'}_1" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoSize{$zone1}}">
							</td>
							<td>
								<select disabled class="items-open-theme-list">
									{foreach from=$themeList item=theme}
									<option {if $theme.id_theme == $configuration.{$hook}->recoTheme{$zone1}} selected {/if} value="{$theme.id_theme}">{$theme.name|escape:'htmlall':'UTF-8'}</option>
									{/foreach}
								</select>
								<a href="#" class="items-open-theme-list" >{l s='Edit' mod='affinityitems'}</a>
							</td>
						</tr>

					</table>

					{if {$hook|lower} == "category" || {$hook|lower} == "search"}
					<table>
						<tr>
							<th>{l s='Selector' mod='affinityitems'}</th>
							<th>{l s='Position' mod='affinityitems'}</th>
						</tr>
						<tr>
							<td><input class="items-selectors-input" name="recoSelector{$hook|escape:'htmlall':'UTF-8'}_1" type="text" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoSelector{$zone1}}"></td>
							<td>
								<select name="recoSelectorPosition{$hook|escape:'htmlall':'UTF-8'}_1">
									<option {if $configuration.{$hook}->recoSelectorPosition{$zone1} == "before"} selected {/if} value="before">{l s='Before' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoSelectorPosition{$zone1} == "after"} selected {/if} value="after">{l s='After' mod='affinityitems'}</option>
								</select>
							</td>
						</tr>
					</table>
					{/if}

					{if {$hook|lower} == "home" || {$hook|lower} == "left" || {$hook|lower} == "right"}
					<div class="items-reco-all-filtered {if $configuration.{$hook|escape:'htmlall':'UTF-8'}->recoType{$zone1} == 'recoAllFiltered'} items-display {/if}">
						<fieldset>
							<legend>{l s='Filtered recommendation' mod='affinityitems'}</legend>
							<select class="items-reco-all-filtered-select" name="recoFilter{$hook|escape:'htmlall':'UTF-8'}_1">
								<option {if $configuration.{$hook}->recoFilter{$zone1} == "onSale"} selected {/if} value="onSale">{l s='By product on sale' mod='affinityitems'}</option>
								<option {if $configuration.{$hook}->recoFilter{$zone1} == "byCategory"} selected {/if} value="byCategory">{l s='By categories' mod='affinityitems'}</option>
								<option {if $configuration.{$hook}->recoFilter{$zone1} == "byAttribute"} selected {/if} value="byAttribute">{l s='By attributes' mod='affinityitems'}</option>
								<option {if $configuration.{$hook}->recoFilter{$zone1} == "byFeature"} selected {/if} value="byFeature">{l s='By features' mod='affinityitems'}</option>
							</select>
							<div class="categoryIds {if $configuration.{$hook|escape:'htmlall':'UTF-8'}->recoFilter{$zone1} == 'byCategory'} items-display {/if}">
								{l s='Filter by category ids (split by semicolon)' mod='affinityitems'} : <input name="categoryIds{$hook|escape:'htmlall':'UTF-8'}_1" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->categoryIds{$zone1}}" type="text">
							</div>
							<div class="attributeIds {if $configuration.{$hook|escape:'htmlall':'UTF-8'}->recoFilter{$zone1} == 'byAttribute'} items-display {/if}">
								{l s='Filter by attribute ids (split by semicolon)' mod='affinityitems'} : <input name="attributeIds{$hook|escape:'htmlall':'UTF-8'}_1" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->attributeIds{$zone1}}" type="text">
							</div>
							<div class="featureIds {if $configuration.{$hook|escape:'htmlall':'UTF-8'}->recoFilter{$zone1} == 'byFeature'} items-display {/if}">
								{l s='Filter by feature ids (split by semicolon)' mod='affinityitems'} : <input name="featureIds{$hook|escape:'htmlall':'UTF-8'}_1" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->featureIds{$zone1}}" type="text">
							</div>
						</fieldset>
					</div>
					{else}
					{if {$hook|lower} != "category" && {$hook|lower} != "search"}<div class="items-reco-all-filtered"></div>{/if}
					{/if}

					<div class="items-theme-list">
						<ul>
							{foreach from=$themeList item=theme}
							{if $theme.name|lower == 'bright' || $theme.name|lower == 'dark'}<a href="#" onClick="showPreview('{$theme.name|escape:'htmlall':'UTF-8'}');return false;">{/if}
							<li>
								<label for="radio-style-white">{$theme.name|escape:'htmlall':'UTF-8'}  {if $theme.name|lower == 'bright' || $theme.name|lower == 'dark'}<i class="fa fa-eye"></i>{/if}  </label>
								<input type="radio" name="recoTheme{$hook|escape:'htmlall':'UTF-8'}_1" value="{$theme.id_theme}" id="radio-style-white"
								{if $theme.id_theme == $configuration.{$hook}->recoTheme{$zone1}} checked="checked" {/if} />    
							</li>
							{if $theme.name|lower == 'bright' || $theme.name|lower == 'dark'}</a>{/if}
							{/foreach}
						</ul>
					</div>

					<table width="100%">
						<tr>
							<td>
								<div class="onoffswitch">
									<input type="hidden" name="reco{$hook|escape:'htmlall':'UTF-8'}_2" value="0">
									<input type="checkbox" name="reco{$hook|escape:'htmlall':'UTF-8'}_2" class="onoffswitch-checkbox" id="reco{$hook|escape:'htmlall':'UTF-8'}_2" value="1" {if $configuration.{$hook}->reco{$zone2} == "1"} checked {/if}>
									<label class="onoffswitch-label" for="reco{$hook|escape:'htmlall':'UTF-8'}_2">
										<span class="onoffswitch-inner"></span>
										<span class="onoffswitch-switch"></span>
									</label>
								</div>
							</td>
							<td>
								<input class="items-selectors-input" name="recoTitle{$hook|escape:'htmlall':'UTF-8'}_2" type="text" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoTitle{$zone2}}">
							</td>
							<td>
								<select class="ae-type-recommendation-select" name="recoType{$hook|escape:'htmlall':'UTF-8'}_2">
									{if {$hook|lower} == "home" || {$hook|lower} == "left" || {$hook|lower} == "right"}
									<option {if $configuration.{$hook}->recoType{$zone2} == "recoAll"} selected {/if} value="recoAll">{l s='Personalized recommendation' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoType{$zone2} == "recoAllFiltered"} selected {/if} value="recoAllFiltered">{l s='Filtered personalized recommendation' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoType{$zone2} == "recoLastSeen"} selected {/if} value="recoLastSeen">{l s='Last liked products' mod='affinityitems'}</option>
									{else if {$hook|lower} == "cart"}
									<option value="recoCart">{l s='Personalized recommendation' mod='affinityitems'}</option>
									{else if {$hook|lower} == "product"}
									<option {if $configuration.{$hook}->recoType{$zone2} == "recoSimilar"} selected {/if} value="recoSimilar">{l s='Personalized recommendation' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoType{$zone2} == "recoUpSell"} selected {/if} value="recoUpSell">{l s='Up selling' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoType{$zone2} == "recoCrossSell"} selected {/if} value="recoCrossSell">{l s='Cross selling' mod='affinityitems'}</option>
									{else if {$hook|lower} == "category"}
									<option {if $configuration.{$hook}->recoType{$zone2} == "recoCategory"} selected {/if} value="recoCategory">{l s='Personalized recommendation' mod='affinityitems'}</option>
									{else if {$hook|lower} == "search"}
									<option {if $configuration.{$hook}->recoType{$zone2} == "recoSearch"} selected {/if} value="recoSearch">{l s='Personalized recommendation' mod='affinityitems'}</option>
									{/if}
								</select>
							</td>
							<td>
								<input class="ae-number-reco-input" type="number" min="1" max="20"  name="recoSize{$hook|escape:'htmlall':'UTF-8'}_2" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoSize{$zone2}}">				
							</td>
							<td>
								<select disabled class="items-open-theme-list">
									{foreach from=$themeList item=theme}
									<option {if $theme.id_theme == $configuration.{$hook}->recoTheme{$zone2}} selected {/if} value="{$theme.id_theme}">{$theme.name|escape:'htmlall':'UTF-8'}</option>
									{/foreach}
								</select>
								<a href="#" class="items-open-theme-list" >{l s='Edit' mod='affinityitems'}</a>
							</td>
						</tr>
					</table>

					{if {$hook|lower} == "category" || {$hook|lower} == "search"}
					<table>
						<tr>
							<th>{l s='Selector' mod='affinityitems'}</th>
							<th>{l s='Position' mod='affinityitems'}</th>
						</tr>
						<tr>
							<td><input class="items-selectors-input" name="recoSelector{$hook|escape:'htmlall':'UTF-8'}_2" type="text" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoSelector{$zone2}}"></td>
							<td>
								<select  name="recoSelectorPosition{$hook|escape:'htmlall':'UTF-8'}_2">
									<option {if $configuration.{$hook}->recoSelectorPosition{$zone2} == "before"} selected {/if} value="before">{l s='Before' mod='affinityitems'}</option>
									<option {if $configuration.{$hook}->recoSelectorPosition{$zone2} == "after"} selected {/if} value="after">{l s='After' mod='affinityitems'}</option>
								</select>
							</td>
						</tr>
					</table>
					{/if}

					{if {$hook|lower} == "home" || {$hook|lower} == "left" || {$hook|lower} == "right"}
					<div class="items-reco-all-filtered {if $configuration.{$hook|escape:'htmlall':'UTF-8'}->recoType{$zone2} == 'recoAllFiltered'} items-display {/if}">
						<fieldset>
							<legend>{l s='Filtered recommendation' mod='affinityitems'}</legend>
							<select class="items-reco-all-filtered-select" name="recoFilter{$hook|escape:'htmlall':'UTF-8'}_2">
								<option {if $configuration.{$hook}->recoFilter{$zone2} == "onSale"} selected {/if} value="onSale">Produits en solde</option>
								<option {if $configuration.{$hook}->recoFilter{$zone2} == "byCategory"} selected {/if} value="byCategory">Par catégorie</option>
								<option {if $configuration.{$hook}->recoFilter{$zone2} == "byAttribute"} selected {/if} value="byAttribute">Par attribut</option>
								<option {if $configuration.{$hook}->recoFilter{$zone2} == "byFeature"} selected {/if} value="byFeature">Par caractéritique</option>
							</select>
							<div class="categoryIds {if $configuration.{$hook|escape:'htmlall':'UTF-8'}->recoFilter{$zone2} == 'byCategory'} items-display {/if}">
								{l s='Filter by category ids (split by semicolon)' mod='affinityitems'} : <input name="categoryIds{$hook|escape:'htmlall':'UTF-8'}_2" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->categoryIds{$zone2}}" type="text">
							</div>
							<div class="attributeIds {if $configuration.{$hook|escape:'htmlall':'UTF-8'}->recoFilter{$zone2} == 'byAttribute'} items-display {/if}">
								{l s='Filter by attribute ids (split by semicolon)' mod='affinityitems'} : <input name="attributeIds{$hook|escape:'htmlall':'UTF-8'}_2" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->attributeIds{$zone2}}" type="text">
							</div>
							<div class="featureIds {if $configuration.{$hook|escape:'htmlall':'UTF-8'}->recoFilter{$zone2} == 'byFeature'} items-display {/if}">
								{l s='Filter by feature ids (split by semicolon)' mod='affinityitems'} : <input name="featureIds{$hook|escape:'htmlall':'UTF-8'}_2" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->featureIds{$zone2}}" type="text">
							</div>
						</fieldset>
					</div>
					{else}
					{if {$hook|lower} != "category" && {$hook|lower} != "search"}<div class="items-reco-all-filtered"></div>{/if}
					{/if}

					<div class="items-theme-list">
						<ul>
							{foreach from=$themeList item=theme}
							<li>
								<label for="radio-style-white">{$theme.name|escape:'htmlall':'UTF-8'}</label>
								<input type="radio" name="recoTheme{$hook|escape:'htmlall':'UTF-8'}_2" value="{$theme.id_theme}" id="radio-style-white"
								{if $theme.id_theme == $configuration.{$hook}->recoTheme{$zone2}} checked="checked" {/if} />    
							</li>
							{/foreach}
						</ul>
					</div>

				</div>
			</div>

			{/foreach}
		</form>
	</div>
</div>

<div id="items-theme-editor">

	<p> > {l s='Settings' mod='affinityitems'} > {l s='Design' mod='affinityitems'} </p>

	{include file="./theme-editor.tpl"}
	<div class="clear"></div>
	<div class="items-title">
		{l s='Additional CSS' mod='affinityitems'}
	</div>
	<form action='#theme-editor' method='POST'/>
	<textarea class="items-css-text-area" name="additionalCss">{$additionalCss|escape:'htmlall':'UTF-8'}</textarea>
	<input type="submit" value="{l s='Save' mod='affinityitems'}" class="items-button-submit items-right">
</form>
</div>

<div class="clear"></div>

<div id="items-support">

	<p> > {l s='Support' mod='affinityitems'} </p>

	<div class="items-support-description">
		<p>{l s='In case of questions or needs: ' mod='affinityitems'}</p>
		<ul>
			<li>{l s='read our FAQ or our Installation guide' mod='affinityitems'}</li>
			<li>{l s='Contact us at' mod='affinityitems'}</li>
			<ul>
				<li>{l s='Commercial department : commercial@affinity-engine.fr | +33 9 80 47 24 83' mod='affinityitems'}</li>
				<li>{l s='Technical department : support@affinity-engine.fr | +33 9 54 52 85 12' mod='affinityitems'}</li>
			</ul>
		</ul>
	</div>

	<div class="items-tabs-support">
		<ul>
			<li class="items-faq-tab items-tab-active" onclick="switchSupportTab('faq')"><span>{l s='FAQ' mod='affinityitems'}</span></li>
			<li class="items-logs-tab" onclick="switchSupportTab('logs')"><span>{l s='Logs' mod='affinityitems'}</span></li>
		</ul>
	</div>

	<div id="items-tab-log">
		{foreach from=$logs item=log}
		<div class="ae-log {if $log.severity == '[ERROR]'} ae-alert {else} ae-info {/if}"><p>[{$log.date_add|escape:'htmlall':'UTF-8'}] {$log.severity|escape:'htmlall':'UTF-8'} {$log.message|escape:'htmlall':'UTF-8'}</p></div><br />
		{/foreach}
	</div>

	<div id="items-tab-wiki">
		<div id="items-wiki"></div>
	</div>

	<div class="clear"></div>
</div>

<div id="items-help">
	
	<p> > {l s='Help' mod='affinityitems'} </p>

	<div class="items-help-explaination">
		<p><span class="items-help-explaination-bold">{l s='You wish some help to install affinity items ?' mod='affinityitems'}</span>
		<br />
		<span class="items-help-explaination-bold">{l s='Please give us your contact details,' mod='affinityitems'}</span>
		<br />
		{l s='we will call you back as soon as possible.' mod='affinityitems'}</p>
	</div>
	
	<div class="items-help-form">
		
		<table>
			<tr>
				<td class="items-help-form-label">
					{l s='Lastname' mod='affinityitems'} :
				</td>
				<td>
					<input type="text" class="items-selectors-input" id="items-help-firstname" />
				</td>
			</tr>

			<tr>
				<td class="items-help-form-label">
					{l s='Firstname' mod='affinityitems'} :
				</td>
				<td>
					<input type="text" class="items-selectors-input" id="items-help-lastname" />
				</td>
			</tr>

			<tr>
				<td class="items-help-form-label">
					{l s='Phone number' mod='affinityitems'} :
				</td>
				<td>
					<input type="text" class="items-selectors-input" id="items-help-phone" />
				</td>
			</tr>
		</table>

		<input type="submit" class="items-help-button items-button items-green" value="{l s='Validate' mod='affinityitems'}"/>

	</div>
</div>

<div id="items-desactivate">

	<div class="items-help-explaination">
		<p> <span class="items-help-explaination-bold">{l s='You have disactivated affinity items.' mod='affinityitems'}</span>
		<br />
		{l s='Please tell us your main reason:' mod='affinityitems'}</p>
	</div>

	<div class="items-desactivate-form">

	<table>
		<tr>
			<td>
				<input type="radio" checked class="items-desactivate-reason" name="items-desactivate-reason" value="{l s='No need' mod='affinityitems'}" />
			</td>
			<td>
				{l s='No need' mod='affinityitems'}
			</td>
		</tr>

		<tr>
			<td>
				<input type="radio" class="items-desactivate-reason" name="items-desactivate-reason" value="{l s='No time' mod='affinityitems'}" />
			</td>
			<td>
				{l s='No time' mod='affinityitems'}
			</td>
		</tr>

		<tr>
			<td>
				<input type="radio" class="items-desactivate-reason" name="items-desactivate-reason" value="{l s='Too complicated' mod='affinityitems'}" />
			</td>			
			<td>
				{l s='Too complicated' mod='affinityitems'}
			</td>
		</tr>

		<tr>
			<td>
				<input type="radio" class="items-desactivate-reason" name="items-desactivate-reason" value="{l s='Too expensive' mod='affinityitems'}" />
			</td>			
			<td>
				{l s='Too expensive' mod='affinityitems'}
			</td>
		</tr>

		<tr>
			<td>
				<input type="radio" class="items-desactivate-reason" name="items-desactivate-reason" value="{l s='Back in few minutes!' mod='affinityitems'}" />
			</td>
			<td>
				{l s='Back in few minutes!' mod='affinityitems'}
			</td>
		</tr>
	</table>

	<input type="submit" class="items-desactivate-button items-button items-green" value="{l s='Validate' mod='affinityitems'}"/>

	</div>

</div>

<div id="items-funnel-step-one">
	<h2>{l s='Recommendations activation' mod='affinityitems'}</h2>
	<p>{l s='You can change the recommendations parameters' mod='affinityitems'}
	<br />
	{l s='at any time in the setup menu' mod='affinityitems'}</p>
	<a class="items-button items-green" href="#" onClick="showPage('funnel-step-two'); return false;">{l s='Simple activation' mod='affinityitems'} <br /> <span class="">{l s='With default parameters' mod='affinityitems'}</span></a>
	<br />
	<a class="items-button items-grey" href="#" onClick="closeFunnel(); return false;">{l s='Advanced activation' mod='affinityitems'} <br /> <span class="">{l s='Change the default parameters' mod='affinityitems'}</span></a>
</div>

<div id="items-funnel-step-two">
	<h2>{l s='Choose your graphic theme' mod='affinityitems'}</h2>
	<p>{l s='You can change the recommendations parameters' mod='affinityitems'}
	<br />
	{l s='at any time in the setup menu' mod='affinityitems'}</p>
	<form method='POST' action="#">
		<div class="items-radio-funnel-style-choice">
			<ul>
				{foreach from=$themeList item=theme}
				{if $theme.name|lower == 'bright' || $theme.name|lower == 'dark'}
				<a href="#" onClick="showPreview('{$theme.name|escape:'htmlall':'UTF-8'}');return false;"><li class="radio-style-{$theme.name|lower}">
					<label for="radio-style-{$theme.name|lower}">
						{$theme.name|escape:'htmlall':'UTF-8'} <i class="fa fa-eye"></i></label>
					<input {if $theme.name|lower == 'bright'} checked {/if} type="radio" name="graphic" value="{$theme.id_theme}" id="radio-style-{$theme.name|lower}" />
				</li></a>
				{/if}
				{/foreach}
			</ul>
		</div>
		<input type="submit" class="items-button items-green" value="{l s='Active recommendations' mod='affinityitems'}" />
	</form>
	<br />
</div>

<div id="items-synchronize-desactivate" class="items-synchronize-message-container">
	<div class="items-synchronize-container-text items-left">			
		{l s='Affinity items is disactivated...' mod='affinityitems'}
	</div>
	<a href="#" onclick="showPage('activation'); return false;"> 
		<div class="items-synchronize-container-button items-green items-right">
			{l s='Activate recommendations' mod='affinityitems'}
		</div>
	</a>
	<div class="clear"></div>
</div>

<div id="items-synchronize-in-progress" class="items-synchronize-message-container">
	<div class="items-synchronize-container-text items-left">			
		{l s='Synchronization and product catalog analysis...' mod='affinityitems'}
		<br>
		{l s='Few minutes more to get recommendations on your website' mod='affinityitems'}
	</div>

	<a href="#" onclick="showPage('activation'); return false;">
		<div class="items-synchronize-container-button items-green items-right">
			{l s='Change recommendation parameters' mod='affinityitems'}
		</div>
	</a>
	
	<div class="clear"></div>
</div>

<div id="items-synchronize-finished" class="items-synchronize-message-container">
	<div class="items-synchronize-container-text items-left">
		{l s='Affinity items is activated and operational' mod='affinityitems'}
	</div>

	<a href="#" onclick="showPage('activation'); return false;">
		<div class="items-synchronize-container-button items-green items-right">
			{l s='Configure recommendation' mod='affinityitems'}			
		</div>
	</a>

	<div class="clear"></div>
</div>

</div>
