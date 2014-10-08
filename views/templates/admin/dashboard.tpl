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
var step = ['Categories', 'Products', 'Carts', 'Orders', 'Actions'];
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
				$(".items-box-synchronization-content").empty();
				if(response._ok == true) {
					if(!response._lock && response._percentage == 100) {
						$(".items-box-synchronization-content").append("{/literal}<p class='items-checked'>{l s='Your system is synchronized' mod='affinityitems'}</p>{literal}");
					} else {
						$(".items-box-synchronization-content").append("{/literal}<p class='items-loading'>{l s='Install in progress, please wait' mod='affinityitems'}...</p>{literal}");
						$(".items-box-synchronization-content").append("{/literal}<p>{l s='Step' mod='affinityitems'} "+ response._step +" / 5 : </p>{literal}");
						$(".items-box-synchronization-content").append("{/literal}<p>"+step[response._step-1]+" {l s='synchronization' mod='affinityitems'}</p>{literal}");
					}
				}
			}});
	setTimeout("synchronize()", 10000);
}

function changeZoneTab(name) {
	{/literal}{foreach from=$hookList item=hook}{literal}
	$('#zone-{/literal}{$hook|lower}{literal}').hide();
	{/literal}{/foreach}{literal}
	$('#zone-'+name+'').show();
}

$(document).ready(function() {
	synchronize();

 	$("#items-wiki").load("http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/fr-page-faq .wiki-holder", function(response, status, xhr) {
    	var html = $("#items-wiki").html();
    	var result = html.replace(/<a href="/g, '<a target="_blank" class="ae-email-color" href="http://developer.affinity-engine.fr/affinityitems/prestashop/wikis/');
    	$("#items-wiki").html(result);
    });

	$('#zone-home').show();
	var slider = $('#slider'),
	input  = $('#input-number');

	input.keydown(function( e ) {
		var value = Number( slider.val() );

		switch ( e.which ) {
			case 38: slider.val( value + 5 ); break;
			case 40: slider.val( value - 5 ); break;
		}
	});

	var dropoptions = {
		accept:".items-item"
	};

	var tabs = new Array();
	$('.items-tab').each(function(index, value) {
		tabs.push(value.id);
	});
	var hash = window.location.hash.substring(1);
	if(hash) {
		showTab(hash);
	} else {
		showTab('home');
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

	$.each(tabs, function(index, value) {
		$('#' + value).click(function(){showTab(value);});
	});

	function showTab(name) {
		window.location.hash = '#' + name;
		$.each(tabs, function(index, value) {
			var tab     = $('#' + value);
			var content = $('#content-' + value);

			if(name === value) {
				tab.addClass('active');
				content.show();
			} else {
				tab.removeClass('active');
				content.hide();
			}
		});
	}

	$('#registerTheme').click(function() {
		$('.items-register-theme').slideDown();
		return false;
	});

	$('.zone-tab').click(function() {
		$( ".zone-tab" ).each(function( index ) {
			$(this).css("color", "black");
			$(this).css("font-weight", "initial");
			$(this).css("border", "1px solid #bdc3c7");
			$(this).css("border-bottom-width", "6px");
		});
		$(this).css("color", "#604a7b");
		$(this).css("font-weight", "bold");
		$(this).css("border", "1px solid rgb(96, 74, 123)");
		$(this).css("border-bottom-width", "6px");
	});

	$('.ae-type-recommendation-select').on("change", function() {
		var zone = $(this).parent().parent();
		if($(this).val() == "recoAllFiltered") {
			$(this).closest(zone).find(".items-reco-all-filtered").fadeIn();
		} else {
			$(this).closest(zone).find(".items-reco-all-filtered").hide();
		}
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

	var toolbox = 'default';
	$('.toolbox-button').click(function() {
		$('.' + toolbox + '-toolbox').hide();
		toolbox = $(this).attr('toolbox');
		$('.' + toolbox + '-toolbox').show();
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
				if(checked) {
					$(".items-box-description.notactivate").css("display", "block");
					$(".items-box-description.notactivate").slideUp();
				} else {
					$(".items-box-description.notactivate").slideDown();
				}
			}
		});
	});

	$('.items-tooltip').powerTip({
		placement: 's',
		smartPlacement: true
	});


	$("#slider").noUiSlider({
		start: {/literal}{$abtestingPercentage}{literal},
		range: {
			'min': 0,
			'max': 100
		},
		step: 5,
		connect: 'lower',
		serialization: {
			lower: [
			$.Link({
				target: $('#input-number'),
				format: {
					decimals: 0
				}
			})
			]
		}
	}).change( function(){
		$.ajax({
			{/literal}{if $ajaxController}{literal}
			url: "index.php?controller=AEAjax&configure=affinityitems&ajax",
			{/literal}{else}{literal}
			url: "{/literal}{$module_dir|escape:'htmlall':'UTF-8'}{literal}ajax/property.php",
			{/literal}{/if}{literal}
			type: "POST",
			data : {"percentage" : $("#input-number").val(), "token" : "{/literal}{$prestashopToken|escape:'htmlall':'UTF-8'}{literal}", "aetoken" : '{/literal}{$aetoken}{literal}'},
			async: false,
			success: function (e, t, n) {}
		});
	});
	{/literal}{include file="./live-editor.tpl"}{literal}
});
{/literal}
</script>

<div class="items-wrapper">
	<div class="items-header">
		<div class="aelogo"></div>
	</div>
	<div class="items-tabs">
		<div id="home" class="items-first-tab items-tab active">
			<i class="fa fa-home"></i> 
			{l s='Home' mod='affinityitems'}
		</div>
		<div id="config" class="items-tab">
			<i class="fa fa-wrench"></i> 
			{l s='Configuration' mod='affinityitems'}
		</div>
		<div id="theme-editor" class="items-tab">
			<i class="fa fa-wrench"></i> 
			{l s='Theme editor' mod='affinityitems'}
		</div>
		<div id="logs" class="items-tab">
			<i class="fa fa-list-alt"></i> 
			{l s='Logs' mod='affinityitems'}
		</div>
		<div id="support" class="items-tab items-support">
			<i class="fa fa-life-ring"></i>
			{l s='Support' mod='affinityitems'}
		</div>
	</div>
	<div id="content-home" class="items-content">
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
				<object type="text/html" data="http://www.youtube.com/embed/AIEfj2UV-qU" width="400" height="236"></object>
			</div>
		</div>
		<div class="clear"></div>
		<div class="ae-info-auth">
			{l s='We can install and configure the Affinity Items module for your website at no extra cost' mod='affinityitems'}
			<br>
			{l s='Do not hesitate to contact us for any questions :' mod='affinityitems'}
			<ul>
				<li>{l s='The technical support at' mod='affinityitems'} <span class="ae-email-color">+33 9 54 52 85 12</span> {l s='or contact' mod='affinityitems'} <a class="ae-email-color" href="mailto:mathieu@affinity-engine.fr">mathieu@affinity-engine.fr</a></li>
				<li>{l s='The commercial service at' mod='affinityitems'} <span class="ae-email-color">+33 9 80 47 24 83</span></li>
			</ul>
		</div>
		<div class="clear"></div>
		<div class="items-title">
			{l s='Général' mod='affinityitems'}
		</div>
		<div class="items-box">
			<div class="items-box-title">
				{l s='General activation' mod='affinityitems'}
			</div>
			<div class="items-box-content">
				<div class="items-box-description notactivate{if $recommendation == 1} items-hide {/if}">
					{l s='Warning: the recommendation is not yet activated' mod='affinityitems'}
					{l s='After having configured the different recommendation areas, make sure to enable the general recommendation' mod='affinityitems'}
				</div>
				<div class="clear"></div>
				<div class="onoffswitch">
					<input type="checkbox" name="onoffswitch" class="onoffswitch-checkbox" id="myonoffswitch" {if $recommendation==1} checked {/if}>
					<label class="onoffswitch-label" for="myonoffswitch">
						<span class="onoffswitch-inner"></span>
						<span class="onoffswitch-switch"></span>
					</label>
				</div>
			</div>
		</div>
		<div class="items-box">
			<div class="items-box-title">
				{l s='Account' mod='affinityitems'}
			</div>
			<div class="items-box-content">
				<div class="items-box-description">
					{l s='Manage your payment options and access your invoices in the customer area. Also find all the system messages and more detailed statistics on the impact of your personnalization service.' mod='affinityitems'}
				</div>
				<div class="clear"></div>
				{if isset($data->authToken)}
				<a class="items-manager-button" target="_blank" href="http://manager.affinityitems.com/login/{$siteId|escape:'htmlall':'UTF-8'}/{$data->authToken|escape:'htmlall':'UTF-8'}">
					<div class="items-button">
						{l s='Access my account' mod='affinityitems'}
					</div>
				</a>
				{/if}
			</div>
		</div>
		<div class="items-box">
			<div class="items-box-title">
				{l s='Synchronization' mod='affinityitems'} 
			</div>
			<div class="items-box-content">
				<div class="items-box-description">
					<div class="items-box-synchronization-content"></div>
				</div>
			</div>
			<div class="items-box-footer">
				<div class="items-detail grow">
					<a class="items-tooltip" title="{l s='The personalization service analyzes your catalog and your sales history to compute the profiles of your products and your users.' mod='affinityitems'} <br /> {l s='After this initialization step, the customization service can suggest relevant recommendations to each visitor, even if they come on your website for the first time. The new products and members are then synchronized along the way.' mod='affinityitems'} <br /> {l s='The first step is few minutes to few hours long, depending on the size of your database and the performances of your server.' mod='affinityitems'}" href="#">{l s='More about' mod='affinityitems'}</a>
				</div>
			</div>
		</div>
		<div class="clear"></div>
		<div class="items-title">
			{l s='Statistics' mod='affinityitems'}
		</div>
		<div class="items-box">
			<div class="items-box-title">
				{l s='Guests with' mod='affinityitems'} {l s='recommendations' mod='affinityitems'}
			</div>
			<div class="items-box-content">
				<input id="input-number" type="text">% 
				<div id="slider"></div>
			</div>
			<div class="items-box-footer">
				<div class="items-detail grow">
					<a class="items-tooltip"  title="{l s='The outcome measurement is based on the AB Testing method, an unbiased and reliable impact measure, no matter the conditions' mod='affinityitems'}<br>{l s='In this method, a control group of visitors is not eligible for the recommandation.' mod='affinityitems'}<br>{l s='You can control the AB Testing groups' mod='affinityitems'} : <br>• {l s='First test our solution with a low rate of recommandation' mod='affinityitems'} <br>• {l s='Maximize the rate to benefit from the full recommandation impact' mod='affinityitems'}" href="#">{l s='More about' mod='affinityitems'}</a>				
				</div>
			</div>
		</div>
		<div class="items-box items-stat">
			<div class="items-box-title">
				{l s='Recommendation number' mod='affinityitems'}
				{l s='last 30 days' mod='affinityitems'}
			</div>
			<div class="items-box-content">
				<div class="items-main-stat">
					{if isset($data->recommendation)}{$data->recommendation} recos{else} <img src="{$module_dir|escape:'htmlall':'UTF-8'}/resources/img/error.png"> {/if}
				</div>
			</div>
		</div>
		<div class="items-box items-stat">
			<div class="items-box-title">
				{l s='Sales impact' mod='affinityitems'}
			</div>
			<div class="items-box-content">
				<div class="items-main-stat">
					{if !empty($statistics)} {if $statistics->salesImpactByPercentage > 0} + {/if} 
					{$statistics->salesImpactByPercentage|string_format:"%.2f"} % 
					{else} 
					{l s='Impact statistics under construction' mod='affinityitems'}
					{/if}
				</div>
			</div>
			<div class="items-box-footer">
				<div class="items-detail grow">
					<a class="items-tooltip"  title="{l s='The outcome measurement becomes significant after an observation period of 2-6 weeks, depending on the frequency of the customers orders on your site and the impact of the personnalization' mod='affinityitems'} <br> {l s='The outcome measurement is automatically displayed when the significance test is conclusive.' mod='affinityitems'}<br>{l s='The percentage value shows the turnover increase by website visitor benefiting from the recommandation, compared to those without recommandation.' mod='affinityitems'}<br>{l s='This AB Testing method gives an unbiased measurement: the external factors like seasonal sales and weather, as well as your marketing activities, SEO or traffic acquisition, have no influence on the measure.' mod='affinityitems'}<br>{l s='It only quantifies the global impact of the personnalization offered by Affinity Items.' mod='affinityitems'}"href="#">{l s='More about' mod='affinityitems'}</a>				
				</div>
			</div>
		</div>
		{if !empty($statistics)}
		<div class="items-box items-line">
			<div class="items-box-title">
				<strong>{l s='Detailed statistics.' mod='affinityitems'}</strong> {l s='Recommendation effect on the website performance' mod='affinityitems'}
			</div>
			<div class="items-line-item">
				<div class="items-box-title">
					{l s='Turnover' mod='affinityitems'}
				</div>
				<div class="items-box-content">
					<div class="items-third-stat">
						{$statistics->sales|string_format:"%.2f"} €
					</div>
					<div class="items-main-stat">
						{if $statistics->salesImpactByPercentage > 0} + {/if} {$statistics->salesImpactByPercentage|string_format:"%.2f"} %
					</div>
					<div class="items-second-stat">
						{if $statistics->salesImpact > 0} + {/if} {$statistics->salesImpact|string_format:"%.2f"} €
					</div>
				</div>
			</div>
			<div class="items-line-item">
				<div class="items-box-title">
					{l s='Conversion rate' mod='affinityitems'}
				</div>
				<div class="items-box-content">
					<div class="items-third-stat">
						{$statistics->conversionRate|string_format:"%.2f"} %
					</div>
					<div class="items-main-stat">
						{if $statistics->conversionRateImpactByPercentage > 0} + {/if} {$statistics->conversionRateImpactByPercentage|string_format:"%.2f"} %
					</div>
					<div class="items-second-stat">
						{if $statistics->orderImpact > 0} + {/if} {$statistics->orderImpact|string_format:"%.2f"} {l s='paniers' mod='affinityitems'}
					</div>
				</div>
			</div>
			<div class="items-line-item">
				<div class="items-box-title">
					{l s='Average invoice' mod='affinityitems'}
				</div>
				<div class="items-box-content">
					<div class="items-third-stat">
						{$statistics->averageOrderImpact|string_format:"%.2f"} €
					</div>
					<div class="items-main-stat">
						{if $statistics->averageOrderImpactByPercentage > 0} + {/if} {$statistics->averageOrderImpactByPercentage|string_format:"%.2f"} %
					</div>
					<div class="items-second-stat">
						{if $statistics->averageOrderImpactByAmount > 0} + {/if} {$statistics->averageOrderImpactByAmount|string_format:"%.2f"} {l s='€/panier' mod='affinityitems'}
					</div>
				</div>
			</div>
		</div>
		{/if}
		<div class="clear"></div>
	
		<div class="items-title">
			{l s='Other' mod='affinityitems'}
		</div>

		<form action='#home' method='POST'/>
		<div class="items-box">
			<div class="items-box-title">
				{l s='Rescind' mod='affinityitems'}
			</div>
			<div class="items-box-content">
				<input id="rescind" type="checkbox" name="breakContract" {if $breakContract == "1"} checked="checked" {/if}>
				<label for="rescind">{l s='Check this box to have your website data deleted on our platform after the uninstallation' mod='affinityitems'}</label><br>
			</div>
		</div>
		<div class="items-box">
			<div class="items-box-title">
				{l s='A/B Testing' mod='affinityitems'}<br>{l s='IP Blacklist' mod='affinityitems'}
			</div>
			<div class="items-box-content">
				<input type="text" name="blacklist" value="{if !empty($blacklist)}{foreach from=$blacklist item=ip}{$ip|escape:'htmlall':'UTF-8'};{/foreach}{/if}">
			</div>
			<div class="items-box-footer">
				<div class="items-detail grow">
					<a class="items-tooltip" title="" href="#">{l s='More about' mod='affinityitems'}</a>				
				</div>
			</div>			
		</div>
		<div class="items-box">
			<div class="items-box-title">
				{l s='Frequency' mod='affinityitems'}<br>{l s='of the safety synchronization' mod='affinityitems'}
			</div>
			<div class="items-box-content">
				<input type="text" class="items-sync-diff" name="syncDiff" value="{$syncDiff|escape:'htmlall':'UTF-8'}"> {l s='minutes' mod='affinityitems'}
			</div>
		</div>
		<input type="submit" value="{l s='Save' mod='affinityitems'}" class="items-button-submit items-right">
		<div class="clear"></div>
		</form>
	</div>

	<div id="content-config">

		<div class="items-title">
			{l s='Recommendation configuration' mod='affinityitems'}			
			<span class="visit" onclick="javascript:introJs().start();"> {l s='Help' mod='affinityitems'}</span>
		</div>

		<div class="zone-config">

		<form action='#config' method='POST'/>

		<input type="hidden" name="configZoneReco" value="1">

		<div class="zone-tabs">
			{foreach from=$hookList item=hook}
			{assign var="zone1" value="{$hook}_1"}
			{assign var="zone2" value="{$hook}_2"}
			<div class="zone-tab {if $hook=='Home'} zone-tab-selected {/if}" onClick="changeZoneTab('{$hook|lower}')">
				{$hook|escape:'htmlall':'UTF-8'}
				{if $configuration.{$hook}->reco{$zone1} == "1" || $configuration.{$hook}->reco{$zone2} == "1"} 
				<span class="lightfire on">(on)</span>
				{else}
				<span class="lightfire">(off)</span>
				{/if}
			</div>
			{/foreach}
		</div>

		{foreach from=$hookList item=hook}
		{assign var="zone1" value="{$hook}_1"}
		{assign var="zone2" value="{$hook}_2"}

		<div class="zone" id="zone-{$hook|lower}">
			<span class="title">
				{$hook|escape:'htmlall':'UTF-8'}
			</span>
			<span class="description" data-step="1" data-intro="Pour chaque recommandation vous aurez une explication ici.">
			</span>
			<div class="one" data-step="2" data-intro="Dans ce formulaire, vous configurez la zone haute de la recommandation">
				<div class="position">{l s='First recommendation zone' mod='affinityitems'}</div>
				<div class="position-options">
					<div class="onoffswitch" data-step="3" data-intro="Un bouton pour activer la zone">
						<input type="hidden" name="reco{$hook|escape:'htmlall':'UTF-8'}_1" value="0">
						<input type="checkbox" name="reco{$hook|escape:'htmlall':'UTF-8'}_1" class="onoffswitch-checkbox" id="reco{$hook|escape:'htmlall':'UTF-8'}_1" value="1" {if $configuration.{$hook}->reco{$zone1} == "1"} checked {/if}>
						<label class="onoffswitch-label" for="reco{$hook|escape:'htmlall':'UTF-8'}_1">
							<span class="onoffswitch-inner"></span>
							<span class="onoffswitch-switch"></span>
						</label>
					</div>
					<label>{l s='Theme' mod='affinityitems'} :</label>
					<select data-step="4" data-intro="Un champ pour choisir le style graphique de la zone. Par défaut le style utilisera les classes natives Prestashop si votre design a été conçu dans les normes Prestashop." name="recoTheme{$hook|escape:'htmlall':'UTF-8'}_1">
						{foreach from=$themeList item=theme}
						<option {if $theme.id_theme == $configuration.{$hook}->recoTheme{$zone1}} selected {/if} value="{$theme.id_theme}">{$theme.name}</option>
						{/foreach}
					</select>
					<label>{l s='Type' mod='affinityitems'} :</label>
					<select class="ae-type-recommendation-select" data-step="5" data-intro="Un champ pour choisir le type de recommandation. La recommandation est personnalisée par défaut, mais vous pouvez utiliser la recommandation complémentaire (cross sell) ou [...]" name="recoType{$hook|escape:'htmlall':'UTF-8'}_1">
						{if {$hook|lower} == "home" || {$hook|lower} == "left" || {$hook|lower} == "right"}
						<option {if $configuration.{$hook}->recoType{$zone1} == "recoAll"} selected {/if} value="recoAll">Recommandation personnalisée</option>
						<option {if $configuration.{$hook}->recoType{$zone1} == "recoAllFiltered"} selected {/if} value="recoAllFiltered">Recommandation personnalisée filtrée</option>
						<option {if $configuration.{$hook}->recoType{$zone1} == "recoLastSeen"} selected {/if} value="recoLastSeen">Recommandation derniers produits aimés</option>
						{else if {$hook|lower} == "cart"}
						<option value="recoCart">Recommandation personnalisée</option>
						{else if {$hook|lower} == "product"}
						<option {if $configuration.{$hook}->recoType{$zone1} == "recoSimilar"} selected {/if} value="recoSimilar">Recommandation personnalisée</option>
						<option {if $configuration.{$hook}->recoType{$zone1} == "recoUpSell"} selected {/if} value="recoUpSell">Up selling</option>
						<option {if $configuration.{$hook}->recoType{$zone1} == "recoCrossSell"} selected {/if} value="recoCrossSell">Cross selling</option>
						{else if {$hook|lower} == "category"}
						<option {if $configuration.{$hook}->recoType{$zone1} == "recoCategory"} selected {/if} value="recoCategory">Recommandation personnalisée</option>
						{else if {$hook|lower} == "search"}
						<option {if $configuration.{$hook}->recoType{$zone1} == "recoSearch"} selected {/if} value="recoSearch">Recommandation personnalisée</option>
						{/if}
					</select>
					<br /><br /><br /><br />
					<label class="items-selectors-label">{l s='Title zone' mod='affinityitems'} :</label>
					<input class="items-selectors-input" name="recoTitle{$hook|escape:'htmlall':'UTF-8'}_1" type="text" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoTitle{$zone1}}">
					{if {$hook|lower} == "category" || {$hook|lower} == "search"}
					<label class="items-selectors-label">{l s='Selector' mod='affinityitems'} :</label>
					<input class="items-selectors-input" name="recoSelector{$hook|escape:'htmlall':'UTF-8'}_1" type="text" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoSelector{$zone1}}">
					<br /><br /><br /><br />
					<label class="items-selectors-position">{l s='Position' mod='affinityitems'} :</label>
					<select  name="recoSelectorPosition{$hook|escape:'htmlall':'UTF-8'}_1">
						<option {if $configuration.{$hook}->recoSelectorPosition{$zone1} == "before"} selected {/if} value="before">Before</option>
						<option {if $configuration.{$hook}->recoSelectorPosition{$zone1} == "after"} selected {/if} value="after">After</option>
					</select>
					{/if}
					<label class="ae-number-reco-label">{l s='Recommendation number' mod='affinityitems'} :</label>
					<input class="ae-number-reco-input" type="number" min="1" max="20" name="recoSize{$hook|escape:'htmlall':'UTF-8'}_1" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoSize{$zone1}}">
				</div>
				<div class="clear"></div>
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
				{/if}
			</div>
			<div class="clear"></div>
			<div class="items-hr"></div>
			<div class="two" data-step="6" data-intro="La deuxième zone permet d'afficher une seconde barre de recommandation en dessous de la première.">
				<div class="position">{l s='Second recommendation zone' mod='affinityitems'}</div>
				<div class="position-options">
					<div class="onoffswitch">
						<input type="hidden" name="reco{$hook|escape:'htmlall':'UTF-8'}_2" value="0">
						<input type="checkbox" name="reco{$hook|escape:'htmlall':'UTF-8'}_2" class="onoffswitch-checkbox" id="reco{$hook|escape:'htmlall':'UTF-8'}_2" value="1" {if $configuration.{$hook}->reco{$zone2} == "1"} checked {/if}>
						<label class="onoffswitch-label" for="reco{$hook|escape:'htmlall':'UTF-8'}_2">
							<span class="onoffswitch-inner"></span>
							<span class="onoffswitch-switch"></span>
						</label>
					</div>
					<label>{l s='Theme' mod='affinityitems'} :</label>
					<select name="recoTheme{$hook|escape:'htmlall':'UTF-8'}_2">
						{foreach from=$themeList item=theme}
						<option {if $theme.id_theme == $configuration.{$hook}->recoTheme{$zone2}} selected {/if} value="{$theme.id_theme}">{$theme.name}</option>
						{/foreach}
					</select>
					<label>{l s='Type' mod='affinityitems'} :</label>
					<select class="ae-type-recommendation-select" name="recoType{$hook|escape:'htmlall':'UTF-8'}_2">
						{if {$hook|lower} == "home" || {$hook|lower} == "left" || {$hook|lower} == "right"}
						<option {if $configuration.{$hook}->recoType{$zone2} == "recoAll"} selected {/if} value="recoAll">Recommandation personnalisée</option>
						<option {if $configuration.{$hook}->recoType{$zone2} == "recoAllFiltered"} selected {/if} value="recoAllFiltered">Recommandation personnalisée filtrée</option>
						<option {if $configuration.{$hook}->recoType{$zone2} == "recoLastSeen"} selected {/if} value="recoLastSeen">Recommandation derniers produits aimés</option>
						{else if {$hook|lower} == "cart"}
						<option value="recoCart">Recommandation personnalisée</option>
						{else if {$hook|lower} == "product"}
						<option {if $configuration.{$hook}->recoType{$zone2} == "recoSimilar"} selected {/if} value="recoSimilar">Recommandation personnalisée</option>
						<option {if $configuration.{$hook}->recoType{$zone2} == "recoUpSell"} selected {/if} value="recoUpSell">Up selling</option>
						<option {if $configuration.{$hook}->recoType{$zone2} == "recoCrossSell"} selected {/if} value="recoCrossSell">Cross selling</option>
						{else if {$hook|lower} == "category"}
						<option {if $configuration.{$hook}->recoType{$zone2} == "recoCategory"} selected {/if} value="recoCategory">Recommandation personnalisée</option>
						{else if {$hook|lower} == "search"}
						<option {if $configuration.{$hook}->recoType{$zone2} == "recoSearch"} selected {/if} value="recoSearch">Recommandation personnalisée</option>
						{/if}
					</select>
					<br /><br /><br /><br />
					<label class="items-selectors-label">{l s='Title zone' mod='affinityitems'} :</label>
					<input class="items-selectors-input" name="recoTitle{$hook|escape:'htmlall':'UTF-8'}_2" type="text" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoTitle{$zone2}}">
					{if {$hook|lower} == "category" || {$hook|lower} == "search"}
					<label class="items-selectors-label">{l s='Selector' mod='affinityitems'} :</label>
					<input class="items-selectors-input" name="recoSelector{$hook|escape:'htmlall':'UTF-8'}_2" type="text" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoSelector{$zone2}}">
					<br /><br /><br /><br />
					<label class="items-selectors-position">{l s='Position' mod='affinityitems'} :</label>
					<select  name="recoSelectorPosition{$hook|escape:'htmlall':'UTF-8'}_2">
						<option {if $configuration.{$hook}->recoSelectorPosition{$zone2} == "before"} selected {/if} value="before">Before</option>
						<option {if $configuration.{$hook}->recoSelectorPosition{$zone2} == "after"} selected {/if} value="after">After</option>
					</select>
					{/if}
					<label class="ae-number-reco-label">{l s='Recommendation number' mod='affinityitems'} :</label>
					<input class="ae-number-reco-input" type="number" min="1" max="20"  name="recoSize{$hook|escape:'htmlall':'UTF-8'}_2" value="{$configuration.{$hook|escape:'htmlall':'UTF-8'}->recoSize{$zone2}}">					
				</div>
				<div class="clear"></div>
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
				{/if}
			</div>
		</div>
		{/foreach}
		<input type="submit" value="{l s='Save' mod='affinityitems'}" class="items-button-submit items-right">
		<div class="clear"></div>
		</form>
		</div>
</div>
<div id="content-theme-editor">
	{include file="./theme-editor.tpl"}
	<div class="clear"></div>
	<div class="items-title">
		{l s='Additional CSS' mod='affinityitems'}
	</div>
	<form action='#config' method='POST'/>
	<textarea class="items-css-text-area" name="additionalCss">{$additionalCss|escape:'htmlall':'UTF-8'}</textarea>
	<input type="submit" value="{l s='Save' mod='affinityitems'}" class="items-button-submit items-right">
	</form>
	<div class="clear"></div>
</div>
<div id="content-logs">
	{foreach from=$logs item=log}
	<div class="ae-log {if $log.severity == '[ERROR]'} ae-alert {else} ae-info {/if}"><p>[{$log.date_add|escape:'htmlall':'UTF-8'}] {$log.severity|escape:'htmlall':'UTF-8'} {$log.message|escape:'htmlall':'UTF-8'}</p></div><br />
	{/foreach}
</div>
<div id="content-support">
	<div class="items-support-description">
		<h2 class="items-title"><i class="fa fa-life-ring"></i>  Support</h2>
		{l s='If you\'re having a problem with your Affinity Items module, please read the' mod='affinityitems'} {l s='FAQ' mod='affinityitems'} {l s=' or contact' mod='affinityitems'}
		<br />
		<br />
		<ul>
			<li>{l s='The technical support at' mod='affinityitems'} <span class="ae-email-color">+33 9 54 52 85 12</span> {l s='or contact' mod='affinityitems'} <a class="ae-email-color" href="mailto:mathieu@affinity-engine.fr">mathieu@affinity-engine.fr</a></li>
			<li>{l s='The commercial service at' mod='affinityitems'} <span class="ae-email-color">+33 9 80 47 24 83</span></li>
		</ul>
	</div>
	<div id="items-wiki"></div>
	<div class="clear"></div>
</div>
</div>