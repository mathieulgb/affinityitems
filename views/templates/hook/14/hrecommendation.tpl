{*
* 2007-2013 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2013 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{foreach from=$recommendations item=reco name=affinityitemsRecommendations}
{if isset($reco.aeproducts) AND $reco.aeproducts}
{if isset($reco.configuration)}<div class="ae-area ae-{$reco.configuration->area|escape:'htmlall'}">{/if}
	<div {if $reco.theme.backgroundDisplayOptions} style=" {if !$reco.theme.backgroundColorTransparent} background-color: {$reco.theme.backgroundColor}; {/if} border: {$reco.theme.backgroundBorderSize}px solid {$reco.theme.backgroundBorderColor}; border-radius: {$reco.theme.backgroundBorderRoundedSize}px" {/if} id="{$reco.theme.backgroundProductsBlockId}" class="{$reco.theme.backgroundProductsBlockClass}">
		{if $reco.theme.titleActivation}<h4 {if $reco.theme.titleDisplayOptions} style="color: {$reco.theme.titleColor}; font-size: {$reco.theme.titleSize}px; border: {$reco.theme.titleBorderSize}px solid {$reco.theme.titleBorderColor}; border-radius: {$reco.theme.titleBorderRoundedSize}px; {if !$reco.theme.titleBackgroundColorTransparent} background-color: {$reco.theme.titleBackgroundColor}; text-align: {$reco.theme.titleAlign}; line-height: {$reco.theme.titleLineHeight}px; {/if}"{/if} class="{$reco.theme.titleClass}"> {if isset($reco.titleZone)} {$reco.titleZone} {else} {l s='We recommend' mod='affinityitems'} {/if}</h4>{/if}	
		<div id="{$reco.theme.backgroundContentId}" class="{$reco.theme.backgroundContentClass}">
		{assign var='liHeight' value=$reco.theme.productHeight}
		{assign var='nbItemsPerLine' value=$reco.theme.productNumberOnLine}
		{assign var='nbLi' value=$reco.aeproducts|@count}
		{math equation="nbLi/nbItemsPerLine" nbLi=$nbLi nbItemsPerLine=$nbItemsPerLine assign=nbLines}
		{math equation="nbLines*liHeight" nbLines=$nbLines|ceil liHeight=$liHeight assign=ulHeight}
			<ul id="{$reco.theme.backgroundListId}" class="{$reco.theme.backgroundListClass}" style="height:{$ulHeight}px;">
			{foreach from=$reco.aeproducts item=product name=affinityItemsProducts}
			<li {if $reco.theme.productDisplayOptions} style="height: {$reco.theme.productHeight}px;width: {$reco.theme.productWidth}px; {if !$reco.theme.productBackgroundColorTransparent} background-color: {$reco.theme.productBackgroundColor}; {/if} border: {$reco.theme.productBorderSize}px solid {$reco.theme.productBorderColor}; border-radius: {$reco.theme.productBorderRoundedSize}px; {if $smarty.foreach.affinityItemsProducts.iteration%$nbItemsPerLine != 0} margin-right: {$reco.theme.productMarginRight}px{/if}" {/if} id="{$reco.theme.productId}" class="{$reco.theme.productClass} {if $smarty.foreach.affinityItemsProducts.first}first_item{elseif $smarty.foreach.affinityItemsProducts.last}last_item{else}item{/if} {if $smarty.foreach.affinityItemsProducts.iteration%$nbItemsPerLine == 0}last_item_of_line{elseif $smarty.foreach.affinityItemsProducts.iteration%$nbItemsPerLine == 1}clear{/if} {if $smarty.foreach.affinityItemsProducts.iteration > ($smarty.foreach.affinityItemsProducts.total - ($smarty.foreach.affinityItemsProducts.total % $nbItemsPerLine))}last_line{/if}">
				{if $reco.theme.productTitleActivation} <h5 {if $reco.theme.productTitleDisplayOptions} style="height: {$reco.theme.productTitleHeight}px" {/if} class="{$reco.theme.productTitleClass}" id="{$reco.theme.productTitleId}"><a rel="{$product.id_product|escape:'htmlall'}" {if isset($product.link)} {if $reco.theme.productTitleDisplayOptions} style="color:{$reco.theme.productTitleColor};font-size: {$reco.theme.productTitleSize}px; text-align: {$reco.theme.productTitleAlign}; line-height: {$reco.theme.productTitleLineHeight}px;"{/if} href="{$product.link}"{/if} title="{$product.name|truncate:32:'...'|escape:'htmlall':'UTF-8'}">{$product.name|truncate:27:'...'|escape:'htmlall':'UTF-8'}</a></h5> {/if}
				{if $reco.theme.productDescriptionActivation} <div {if $reco.theme.productDescriptionDisplayOptions} style="height: {$reco.theme.productDescriptionHeight}px" {/if} id="{$reco.theme.productDescriptionId}" class="{$reco.theme.productDescriptionClass}"><a rel="{$product.id_product|escape:'htmlall'}" {if $reco.theme.productDescriptionDisplayOptions} style="color:{$reco.theme.productDescriptionColor};font-size: {$reco.theme.productDescriptionSize}px; text-align: {$reco.theme.productDescriptionAlign}; line-height: {$reco.theme.productDescriptionLineHeight}px;"{/if} {if isset($product.link)} href="{$product.link}"{/if} title="{l s='More' mod='homefeatured'}">{$product.description_short|strip_tags|truncate:115:'...'}</a></div> {/if}
				<a rel="{$product.id_product|escape:'htmlall'}" {if isset($product.link)} href="{$product.link}"{/if} title="{$product.name|escape:html:'UTF-8'}" id="{$reco.theme.pictureLinkId}" class="{$reco.theme.pictureLinkClass}"><img {if $reco.theme.pictureDisplayOptions} style="border: {$reco.theme.pictureBorderSize}px solid {$reco.theme.pictureBorderColor}; border-radius: {$reco.theme.pictureBorderRoundedSize}px;" {/if} src="{$link->getImageLink($product.link_rewrite, $product.id_image, $reco.theme.pictureResolution)}" height="{$reco.theme.pictureHeight}" width="{$reco.theme.pictureWidth}" alt="{$product.name|escape:html:'UTF-8'}" id="{$reco.theme.pictureId}" class="{$reco.theme.pictureClass}" /></a>
				<div>					
					{if $reco.theme.priceActivation}{if isset($product.show_price) && $product.show_price AND !isset($restricted_country_mode) AND !$PS_CATALOG_MODE}<p id="{$reco.theme.priceContainerId}" class="{$reco.theme.priceContainerClass}" {if $reco.theme.priceDisplayOptions} style="height: {$reco.theme.priceHeight}px" {/if}><span id="{$reco.theme.priceId}" class="{$reco.theme.priceClass}" {if $reco.theme.priceDisplayOptions} style="color: {$reco.theme.priceColor}; font-size: {$reco.theme.priceSize}px;" {/if}>{if !$priceDisplay}{convertPrice price=$product.price}{else}{convertPrice price=$product.price_tax_exc}{/if}</span></p>{else}<div style="height:21px;"></div>{/if}{/if}
					{if $reco.theme.detailActivation}<a rel="{$product.id_product|escape:'htmlall'}" {if $reco.theme.detailDisplayOptions} style="color: {$reco.theme.detailColor}; font-size: {$reco.theme.detailSize}px;" {/if} id="{$reco.theme.detailId}" class="{$reco.theme.detailClass}" {if isset($product.link)} href="{$product.link}"{/if} title="{l s='View' mod='homefeatured'}">{l s='View' mod='homefeatured'}</a>{/if}

					{if $reco.theme.cartActivation}
					{if $product.available_for_order AND !isset($restricted_country_mode) AND $product.minimal_quantity == 1 AND $product.customizable != 2 AND !$PS_CATALOG_MODE}
					{if ($product.quantity > 0 OR $product.allow_oosp)}
					<a rel="{$product.id_product|escape:'htmlall'}" {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border: {$reco.theme.cartBorderSize}px solid {$reco.theme.cartBorderColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; {if !$reco.theme.cartBackgroundColorTransparent} background-color: {$reco.theme.cartBackgroundColor}; {/if} font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;"{/if} class="{$reco.theme.cartClass}" id="{$reco.theme.cartId}" rel="nofollow ajax_id_product_{$product.id_product}" {if isset($static_token)} href="{$link->getPageLink('cart.php', true)}?qty=1&amp;id_product={$product.id_product}&amp;token={$static_token}&amp;add" {/if} title="{l s='Add to cart' mod='homefeatured'}">{l s='Add to cart' mod='homefeatured'}</a>
					{else}
					<span class="exclusive">{l s='Add to cart' mod='homefeatured'}</span>
					{/if}
					{else}
					<div style="height:23px;"></div>
					{/if}
					{/if}
				</div>
			</li>
			{/foreach}
		</ul>
	</div>
{if isset($reco.configuration)}</div>{/if}
</div>
{/if}
{/foreach}