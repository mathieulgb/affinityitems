{*
* 2007-2014 PrestaShop
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
*  @copyright  2007-2015 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
{foreach from=$recommendations item=reco name=affinityitemsRecommendations}
{if isset($reco.aeproducts) AND $reco.aeproducts}
<div class="ae-area ae-{$reco.configuration->area|escape:'htmlall'}">
<div {if $reco.theme.backgroundDisplayOptions} style="{if !$reco.theme.backgroundColorTransparent} background-color: {$reco.theme.backgroundColor};{/if} border: {$reco.theme.backgroundBorderSize}px solid {$reco.theme.backgroundBorderColor}; border-radius: {$reco.theme.backgroundBorderRoundedSize}px" {/if} id="{$reco.theme.backgroundProductsBlockId|escape:'htmlall'}" class="{$reco.theme.backgroundProductsBlockClass|escape:'htmlall'}">
	{if $reco.theme.titleActivation}<h4 {if $reco.theme.titleDisplayOptions} style="color: {$reco.theme.titleColor}; font-size: {$reco.theme.titleSize}px; border: {$reco.theme.titleBorderSize}px solid {$reco.theme.titleBorderColor}; border-radius: {$reco.theme.titleBorderRoundedSize}px; {if !$reco.theme.titleBackgroundColorTransparent} background-color: {$reco.theme.titleBackgroundColor}; text-align: {$reco.theme.titleAlign}; line-height: {$reco.theme.titleLineHeight}px; {/if}"{/if} class="{$reco.theme.titleClass|escape:'htmlall'}">{$reco.titleZone}</h4>{/if}
	<div id="{$reco.theme.backgroundContentId|escape:'htmlall'}" class="{$reco.theme.backgroundContentClass|escape:'htmlall'}">
		<ul id="{$reco.theme.backgroundListId|escape:'htmlall'}" class="{$reco.theme.backgroundListClass|escape:'htmlall'}">
			{foreach from=$reco.aeproducts item=product name=affinityItemsProducts}
				<li {if $reco.theme.productDisplayOptions} style="height: {$reco.theme.productHeight}px; width: {$reco.theme.productWidth}px; {if !$reco.theme.titleBackgroundColorTransparent} background-color: {$reco.theme.productBackgroundColor};{/if} border: {$reco.theme.productBorderSize}px solid {$reco.theme.productBorderColor}; border-radius: {$reco.theme.productBorderRoundedSize}px; margin-right: {$reco.theme.productMarginRight}px" {/if}
				 id="{$reco.theme.productId|escape:'htmlall'}" class="{$reco.theme.productClass|escape:'htmlall'} {if $smarty.foreach.affinityItemsProducts.last} last_item{elseif $smarty.foreach.affinityItemsProducts.first} first_item{else} item{/if}">
					<a rel="{$product.id_product|escape:'htmlall'}" href="{$product.link|escape:'html'}" rel="{$product.id_product|escape:'htmlall'}" title="{l s='About' mod='affinityitems'} {$product.name|escape:html:'UTF-8'}" id="{$reco.theme.pictureLinkId}" class="{$reco.theme.pictureLinkClass|escape:'htmlall'}">
					<img {if $reco.theme.pictureDisplayOptions} style="border: {$reco.theme.pictureBorderSize}px solid {$reco.theme.pictureBorderColor}; border-radius: {$reco.theme.pictureBorderRoundedSize}px;" {/if} src="{$link->getImageLink($product.link_rewrite, $product.id_image, $reco.theme.pictureResolution)|escape:'html'}" height="{$reco.theme.pictureHeight}" width="{$reco.theme.pictureWidth}" alt="{$product.name|escape:html:'UTF-8'}" />
					</a>
					<div>
						{if $reco.theme.productTitleActivation}<h5 {if $reco.theme.productTitleDisplayOptions} style="color:{$reco.theme.productTitleColor};font-size: {$reco.theme.productTitleSize}px; text-align: {$reco.theme.productTitleAlign}; line-height: {$reco.theme.productTitleLineHeight}px;"{/if} class="{$reco.theme.productTitleClass}"><a rel="{$product.id_product|escape:'htmlall'}" href="{$product.link|escape:'html'}" rel="{$product.id_product}" title="{l s='About' mod='affinityitems'} {$product.name|escape:html:'UTF-8'}">{$product.name|truncate:14:'...'|escape:html:'UTF-8'}</a></h5>{/if}
						{if $reco.theme.productDescriptionActivation}<p id="{$reco.theme.productDescriptionId}" class="{$reco.theme.productDescriptionClass}"><a rel="{$product.id_product|escape:'htmlall'}" {if $reco.theme.productDescriptionDisplayOptions} style="color:{$reco.theme.productDescriptionColor};font-size: {$reco.theme.productDescriptionSize}px; text-align: {$reco.theme.productDescriptionAlign}; line-height: {$reco.theme.productDescriptionLineHeight}px;"{/if} href="{$product.link|escape:'html'}" rel="{$product.id_product|escape:'htmlall'}" title="{l s='About' mod='affinityitems'} {$product.name|escape:html:'UTF-8'}">{$product.description_short|strip_tags:'UTF-8'|truncate:44}</a></p>{/if}
					</div>
				</li>
			{/foreach}
		</ul>
	</div>
</div>

</div>
{/if}
{/foreach}