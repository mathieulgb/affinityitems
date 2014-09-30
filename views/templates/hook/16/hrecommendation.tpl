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
	*  @copyright  2007-2014 PrestaShop SA
	*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
	*  International Registered Trademark & Property of PrestaShop SA
	*}
	{if !isset($page_name)} {assign var='page_name' value='preview'} {/if}

	{foreach from=$recommendations item=reco name=affinityitemsRecommendations}

	{assign var='nbItemsPerLine' value=$reco.theme.productNumberOnLine}
	{assign var='nbItemsPerLineTablet' value=$reco.theme.productNumberOnLine}
	{assign var='nbItemsPerLineMobile' value=$reco.theme.productNumberOnLine}

	{assign var='nbLi' value=$reco.aeproducts|@count}
	{math equation="nbLi/nbItemsPerLine" nbLi=$nbLi nbItemsPerLine=$nbItemsPerLine assign=nbLines}
	{math equation="nbLi/nbItemsPerLineTablet" nbLi=$nbLi nbItemsPerLineTablet=$nbItemsPerLineTablet assign=nbLinesTablet}

	{if isset($reco.aeproducts) && $reco.aeproducts}

	{if isset($reco.configuration)}<div class="ae-area ae-{$reco.configuration->area|escape:'htmlall'}">{/if}

	<div {if $reco.theme.backgroundDisplayOptions} style="{if !$reco.theme.backgroundColorTransparent}background-color: {$reco.theme.backgroundColor};{/if} border: {$reco.theme.backgroundBorderSize}px solid {$reco.theme.backgroundBorderColor}; border-radius: {$reco.theme.backgroundBorderRoundedSize}px" {/if} id="{$reco.theme.backgroundProductsBlockId}" class="{$reco.theme.backgroundProductsBlockClass}">
		{if $reco.theme.titleActivation}<h4 {if $reco.theme.titleDisplayOptions} style="color: {$reco.theme.titleColor}; font-size: {$reco.theme.titleSize}px; border: {$reco.theme.titleBorderSize}px solid {$reco.theme.titleBorderColor}; border-radius: {$reco.theme.titleBorderRoundedSize}px; {if !$reco.theme.titleBackgroundColorTransparent}background-color: {$reco.theme.titleBackgroundColor}; text-align: {$reco.theme.titleAlign}; line-height: {$reco.theme.titleLineHeight}px; {/if}"{/if} class="{$reco.theme.titleClass}">{if isset($reco.titleZone)} {$reco.titleZone} {else} {l s='We recommend' mod='affinityitems'} {/if}</h4>{/if}
		<div id="{$reco.theme.backgroundContentId}" class="{$reco.theme.backgroundContentClass}">

			<ul{if isset($id) && $id} id="{$id}"{/if} id="{$reco.theme.backgroundListId}" class="{$reco.theme.backgroundListClass} {if isset($class) && $class} {$class}{/if}{if isset($active) && $active == 1} active{/if}">
			{foreach from=$reco.aeproducts item=product name=aeproducts}
			{math equation="(total%perLine)" total=$smarty.foreach.aeproducts.total perLine=$nbItemsPerLine assign=totModulo}
			{math equation="(total%perLineT)" total=$smarty.foreach.aeproducts.total perLineT=$nbItemsPerLineTablet assign=totModuloTablet}
			{math equation="(total%perLineT)" total=$smarty.foreach.aeproducts.total perLineT=$nbItemsPerLineMobile assign=totModuloMobile}
			{if $totModulo == 0}{assign var='totModulo' value=$nbItemsPerLine}{/if}
			{if $totModuloTablet == 0}{assign var='totModuloTablet' value=$nbItemsPerLineTablet}{/if}
			{if $totModuloMobile == 0}{assign var='totModuloMobile' value=$nbItemsPerLineMobile}{/if}
			<li {if $reco.theme.productDisplayOptions} style="height: {$reco.theme.productHeight}px; width: {$reco.theme.productWidth}px;{if !$reco.theme.productBackgroundColorTransparent} background-color: {$reco.theme.productBackgroundColor};{/if} border: {$reco.theme.productBorderSize}px solid {$reco.theme.productBorderColor};{if $smarty.foreach.aeproducts.iteration%$nbItemsPerLine != 0} margin-right: {$reco.theme.productMarginRight}px;{/if} border-radius: {$reco.theme.productBorderRoundedSize}px;" {/if} id="{$reco.theme.productId}" class="{$reco.theme.productClass} {if $page_name == 'index' || $page_name == 'product'} col-xs-12 col-sm-4 col-md-3{else} col-xs-12 col-sm-6 col-md-4{/if}{if $smarty.foreach.aeproducts.iteration%$nbItemsPerLine == 0} last-in-line{elseif $smarty.foreach.aeproducts.iteration%$nbItemsPerLine == 1} first-in-line{/if}{if $smarty.foreach.aeproducts.iteration > ($smarty.foreach.aeproducts.total - $totModulo)} last-line{/if}{if $smarty.foreach.aeproducts.iteration%$nbItemsPerLineTablet == 0} last-item-of-tablet-line{elseif $smarty.foreach.aeproducts.iteration%$nbItemsPerLineTablet == 1} first-item-of-tablet-line{/if}{if $smarty.foreach.aeproducts.iteration%$nbItemsPerLineMobile == 0} last-item-of-mobile-line{elseif $smarty.foreach.aeproducts.iteration%$nbItemsPerLineMobile == 1} first-item-of-mobile-line{/if}{if $smarty.foreach.aeproducts.iteration > ($smarty.foreach.aeproducts.total - $totModuloMobile)} last-mobile-line{/if}">
				<div id="{$reco.theme.productContainerId}" class="{$reco.theme.productContainerClass}" itemscope itemtype="http://schema.org/Product">
					<div id="{$reco.theme.productLeftBlockId}" class="{$reco.theme.productLeftBlockClass}">
						<div class="product-image-container">
							<a class="{$reco.theme.pictureLinkClass}" id="{$reco.theme.pictureLinkId}" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}" itemprop="url">
								<img id="{$reco.theme.pictureId}" class="{$reco.theme.pictureClass}" {if $reco.theme.pictureDisplayOptions} style="border: {$reco.theme.pictureBorderSize}px solid {$reco.theme.pictureBorderColor}; border-radius: {$reco.theme.pictureBorderRoundedSize}px;" {/if} src="{$link->getImageLink($product.link_rewrite, $product.id_image, $reco.theme.pictureResolution)|escape:'html':'UTF-8'}" alt="{if !empty($product.legend)}{$product.legend|escape:'html':'UTF-8'}{else}{$product.name|escape:'html':'UTF-8'}{/if}" title="{if !empty($product.legend)}{$product.legend|escape:'html':'UTF-8'}{else}{$product.name|escape:'html':'UTF-8'}{/if}" height="{$reco.theme.pictureHeight}" width="{$reco.theme.pictureWidth}" itemprop="image" />
							</a>
						</div>
					</div>
					<div id="{$reco.theme.productRightBlockId}" class="{$reco.theme.productRightBlockClass}">
						{if $reco.theme.productTitleActivation}
						<h5 {if $reco.theme.productTitleDisplayOptions} style="height: {$reco.theme.productTitleHeight}px" {/if} class="{$reco.theme.productTitleClass}" id="{$reco.theme.productTitleId}" itemprop="name">
							{if isset($product.pack_quantity) && $product.pack_quantity}{$product.pack_quantity|intval|cat:' x '}{/if}
							<a {if $reco.theme.productTitleDisplayOptions} style="color:{$reco.theme.productTitleColor};font-size: {$reco.theme.productTitleSize}px;text-align: {$reco.theme.productTitleAlign}; line-height: {$reco.theme.productTitleLineHeight}px;"{/if} id="{$reco.theme.productLinkTitleId}" class="{$reco.theme.productLinkTitleClass}" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}" itemprop="url" >
								{$product.name|truncate:45:'...'|escape:'html':'UTF-8'}
							</a>
						</h5>
						{/if}
						{hook h='displayProductListReviews' product=$product}
						{if $reco.theme.productDescriptionActivation}
						<p {if $reco.theme.productDescriptionDisplayOptions} style="height: {$reco.theme.productDescriptionHeight}px;color:{$reco.theme.productDescriptionColor};font-size: {$reco.theme.productDescriptionSize}px; text-align: {$reco.theme.productDescriptionAlign}; line-height: {$reco.theme.productDescriptionLineHeight}px;" {/if} id="{$reco.theme.productDescriptionId}" class="{$reco.theme.productDescriptionClass}" itemprop="description">
							{$product.description_short|strip_tags:'UTF-8'|truncate:360:'...'}
						</p>
						{/if}
						{if $reco.theme.priceActivation}
						{if (!$PS_CATALOG_MODE AND ((isset($product.show_price) && $product.show_price) || (isset($product.available_for_order) && $product.available_for_order)))}
						<div id="{$reco.theme.priceContainerId}" class="{$reco.theme.priceContainerClass}" {if $reco.theme.priceDisplayOptions} style="height: {$reco.theme.priceHeight}px" {/if} itemprop="offers" itemscope itemtype="http://schema.org/Offer">
							{if isset($product.show_price) && $product.show_price && !isset($restricted_country_mode)}
							<span itemprop="price" id="{$reco.theme.priceId}" class="{$reco.theme.priceClass}" {if $reco.theme.priceDisplayOptions} style="color: {$reco.theme.priceColor}; font-size: {$reco.theme.priceSize}px;" {/if}>
								{if !$priceDisplay}{convertPrice price=$product.price}{else}{convertPrice price=$product.price_tax_exc}{/if}
							</span>
							<meta itemprop="priceCurrency" content="{$priceDisplay}" />
							{if isset($product.specific_prices) && $product.specific_prices && isset($product.specific_prices.reduction) && $product.specific_prices.reduction > 0}
							<span id="{$reco.theme.oldPriceId}" class="{$reco.theme.oldPriceClass}">
								{displayWtPrice p=$product.price_without_reduction}
							</span>
							{if $product.specific_prices.reduction_type == 'percentage'}
							<span id="{$reco.theme.priceReductionId}" class="{$reco.theme.priceReductionClass}">-{$product.specific_prices.reduction * 100}%</span>
							{/if}
							{/if}
							{/if}
						</div>
						{/if}
						{/if}
						<div class="button-container">
							{if $product.available_for_order && !isset($restricted_country_mode) && $product.minimal_quantity <= 1 && $product.customizable != 2 && !$PS_CATALOG_MODE}
							{if ($product.allow_oosp || $product.quantity > 0)}
							{if isset($static_token)}
							{if $reco.theme.cartActivation}
							<a {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; font-size: {$reco.theme.cartSize}px;  text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if} class="{$reco.theme.cartClass}" id="{$reco.theme.cartId}" href="{$link->getPageLink('cart',false, NULL, "add=1&amp;id_product={$product.id_product|intval}&amp;token={$static_token}", false)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Add to cart'}" data-id-product="{$product.id_product|intval}">
								<span {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border: {$reco.theme.cartBorderSize}px solid {$reco.theme.cartBorderColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; {if !$reco.theme.cartBackgroundColorTransparent} background: {$reco.theme.cartBackgroundColor};{/if} font-size: {$reco.theme.cartSize}px;  text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if}>{l s='Add to cart'}</span>
							</a>
							{/if}
							{else}
							{if $reco.theme.cartActivation}
							<a {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if} class="{$reco.theme.cartClass}" id="{$reco.theme.cartId}"  href="{$link->getPageLink('cart',false, NULL, 'add=1&amp;id_product={$product.id_product|intval}', false)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Add to cart'}" data-id-product="{$product.id_product|intval}">
								<span {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border: {$reco.theme.cartBorderSize}px solid {$reco.theme.cartBorderColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important;{if !$reco.theme.cartBackgroundColorTransparent} background: {$reco.theme.cartBackgroundColor};{/if} font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if}>{l s='Add to cart'}</span>
							</a>
							{/if}
							{/if}						
							{else}
							{if $reco.theme.cartActivation}
							<span {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if} class="{$reco.theme.cartClass} disabled" id="{$reco.theme.cartId}">
								<span {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border: {$reco.theme.cartBorderSize}px solid {$reco.theme.cartBorderColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important;{if !$reco.theme.cartBackgroundColorTransparent} background: {$reco.theme.cartBackgroundColor};{/if} font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if}>{l s='Add to cart'}</span>
							</span>
							{/if}
							{/if}
							{/if}
							{if $reco.theme.detailActivation}
							<a itemprop="url" {if $reco.theme.detailDisplayOptions} style="color: {$reco.theme.detailColor}; font-size: {$reco.theme.detailSize}px;" {/if} id="{$reco.theme.detailId}" class="{$reco.theme.detailClass}" href="{$product.link|escape:'html':'UTF-8'}" title="{l s='View'}">
								<span>{l s='More'}</span>
							</a>
							{/if}
						</div>
					</div>
				</li>
				{/foreach}
			</ul>
		</div>
	</div>
	{if isset($reco.configuration)}</div>{/if}
	{/if}
	{/foreach}

