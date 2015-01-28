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

	<div {if $reco.theme.backgroundDisplayOptions} style="{if !$reco.theme.backgroundColorTransparent}background-color: {$reco.theme.backgroundColor|escape:'htmlall':'UTF-8'};{/if} border: {$reco.theme.backgroundBorderSize|escape:'htmlall':'UTF-8'}px solid {$reco.theme.backgroundBorderColor|escape:'htmlall':'UTF-8'}; border-radius: {$reco.theme.backgroundBorderRoundedSize|escape:'htmlall':'UTF-8'}px" {/if} id="{$reco.theme.backgroundProductsBlockId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.backgroundProductsBlockClass|escape:'htmlall':'UTF-8'}">
		{if $reco.theme.titleActivation}<h4 {if $reco.theme.titleDisplayOptions} style="color: {$reco.theme.titleColor|escape:'htmlall':'UTF-8'}; font-size: {$reco.theme.titleSize|escape:'htmlall':'UTF-8'}px; border: {$reco.theme.titleBorderSize|escape:'htmlall':'UTF-8'}px solid {$reco.theme.titleBorderColor|escape:'htmlall':'UTF-8'}; border-radius: {$reco.theme.titleBorderRoundedSize|escape:'htmlall':'UTF-8'}px; {if !$reco.theme.titleBackgroundColorTransparent}background-color: {$reco.theme.titleBackgroundColor|escape:'htmlall':'UTF-8'}; text-align: {$reco.theme.titleAlign|escape:'htmlall':'UTF-8'}; line-height: {$reco.theme.titleLineHeight|escape:'htmlall':'UTF-8'}px; {/if}"{/if} class="{$reco.theme.titleClass|escape:'htmlall':'UTF-8'}">{if isset($reco.titleZone)} {$reco.titleZone|escape:'htmlall':'UTF-8'} {else} {l s='We recommend' mod='affinityitems'} {/if}</h4>{/if}
		<div id="{$reco.theme.backgroundContentId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.backgroundContentClass|escape:'htmlall':'UTF-8'}">

			<ul{if isset($id) && $id} id="{$id}"{/if} id="{$reco.theme.backgroundListId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.backgroundListClass|escape:'htmlall':'UTF-8'} {if isset($class) && $class} {$class}{/if}{if isset($active) && $active == 1} active{/if}">
			{foreach from=$reco.aeproducts item=product name=aeproducts}
			{math equation="(total%perLine)" total=$smarty.foreach.aeproducts.total perLine=$nbItemsPerLine assign=totModulo}
			{math equation="(total%perLineT)" total=$smarty.foreach.aeproducts.total perLineT=$nbItemsPerLineTablet assign=totModuloTablet}
			{math equation="(total%perLineT)" total=$smarty.foreach.aeproducts.total perLineT=$nbItemsPerLineMobile assign=totModuloMobile}
			{if $totModulo == 0}{assign var='totModulo' value=$nbItemsPerLine}{/if}
			{if $totModuloTablet == 0}{assign var='totModuloTablet' value=$nbItemsPerLineTablet}{/if}
			{if $totModuloMobile == 0}{assign var='totModuloMobile' value=$nbItemsPerLineMobile}{/if}
			<li {if $reco.theme.productDisplayOptions} style="height: {$reco.theme.productHeight|escape:'htmlall':'UTF-8'}px; width: {$reco.theme.productWidth|escape:'htmlall':'UTF-8'}px;{if !$reco.theme.productBackgroundColorTransparent} background-color: {$reco.theme.productBackgroundColor|escape:'htmlall':'UTF-8'};{/if} border: {$reco.theme.productBorderSize|escape:'htmlall':'UTF-8'}px solid {$reco.theme.productBorderColor|escape:'htmlall':'UTF-8'};{if $smarty.foreach.aeproducts.iteration%$nbItemsPerLine != 0} margin-right: {$reco.theme.productMarginRight|escape:'htmlall':'UTF-8'}px;{/if} border-radius: {$reco.theme.productBorderRoundedSize|escape:'htmlall':'UTF-8'}px;" {/if} id="{$reco.theme.productId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.productClass|escape:'htmlall':'UTF-8'} {if $page_name == 'index' || $page_name == 'product'} col-xs-12 col-sm-4 col-md-3{else} col-xs-12 col-sm-6 col-md-4{/if}{if $smarty.foreach.aeproducts.iteration%$nbItemsPerLine == 0} last-in-line{elseif $smarty.foreach.aeproducts.iteration%$nbItemsPerLine == 1} first-in-line{/if}{if $smarty.foreach.aeproducts.iteration > ($smarty.foreach.aeproducts.total - $totModulo)} last-line{/if}{if $smarty.foreach.aeproducts.iteration%$nbItemsPerLineTablet == 0} last-item-of-tablet-line{elseif $smarty.foreach.aeproducts.iteration%$nbItemsPerLineTablet == 1} first-item-of-tablet-line{/if}{if $smarty.foreach.aeproducts.iteration%$nbItemsPerLineMobile == 0} last-item-of-mobile-line{elseif $smarty.foreach.aeproducts.iteration%$nbItemsPerLineMobile == 1} first-item-of-mobile-line{/if}{if $smarty.foreach.aeproducts.iteration > ($smarty.foreach.aeproducts.total - $totModuloMobile)} last-mobile-line{/if}">
				<div id="{$reco.theme.productContainerId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.productContainerClass|escape:'htmlall':'UTF-8'}" itemscope itemtype="http://schema.org/Product">
					<div id="{$reco.theme.productLeftBlockId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.productLeftBlockClass|escape:'htmlall':'UTF-8'}">
						<div class="product-image-container">
							<a rel="{$product.id_product|escape:'htmlall'}" class="{$reco.theme.pictureLinkClass|escape:'htmlall':'UTF-8'}" id="{$reco.theme.pictureLinkId|escape:'htmlall':'UTF-8'}" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}" itemprop="url">
								<img id="{$reco.theme.pictureId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.pictureClass|escape:'htmlall':'UTF-8'}" {if $reco.theme.pictureDisplayOptions} style="border: {$reco.theme.pictureBorderSize|escape:'htmlall':'UTF-8'}px solid {$reco.theme.pictureBorderColor}; border-radius: {$reco.theme.pictureBorderRoundedSize|escape:'htmlall':'UTF-8'}px;" {/if} src="{$link->getImageLink($product.link_rewrite, $product.id_image, $reco.theme.pictureResolution)|escape:'html':'UTF-8'}" alt="{if !empty($product.legend)}{$product.legend|escape:'html':'UTF-8'}{else}{$product.name|escape:'html':'UTF-8'}{/if}" title="{if !empty($product.legend)}{$product.legend|escape:'html':'UTF-8'}{else}{$product.name|escape:'html':'UTF-8'}{/if}" height="{$reco.theme.pictureHeight}" width="{$reco.theme.pictureWidth}" itemprop="image" />
							</a>
						</div>
					</div>
					<div id="{$reco.theme.productRightBlockId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.productRightBlockClass|escape:'htmlall':'UTF-8'}">
						{if $reco.theme.productTitleActivation}
						<h5 {if $reco.theme.productTitleDisplayOptions} style="height: {$reco.theme.productTitleHeight|escape:'htmlall':'UTF-8'}px" {/if} class="{$reco.theme.productTitleClass|escape:'htmlall':'UTF-8'}" id="{$reco.theme.productTitleId|escape:'htmlall':'UTF-8'}" itemprop="name">
							{if isset($product.pack_quantity) && $product.pack_quantity}{$product.pack_quantity|intval|cat:' x '}{/if}
							<a rel="{$product.id_product|escape:'htmlall'}" {if $reco.theme.productTitleDisplayOptions} style="color:{$reco.theme.productTitleColor};font-size: {$reco.theme.productTitleSize}px;text-align: {$reco.theme.productTitleAlign}; line-height: {$reco.theme.productTitleLineHeight}px;"{/if} id="{$reco.theme.productLinkTitleId}" class="{$reco.theme.productLinkTitleClass}" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}" itemprop="url" >
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
							<meta itemprop="priceCurrency" content="{$priceDisplay|escape:'htmlall':'UTF-8'}" />
							{if isset($product.specific_prices) && $product.specific_prices && isset($product.specific_prices.reduction) && $product.specific_prices.reduction > 0}
							<span id="{$reco.theme.oldPriceId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.oldPriceClass|escape:'htmlall':'UTF-8'}">
								{displayWtPrice p=$product.price_without_reduction}
							</span>
							{if $product.specific_prices.reduction_type == 'percentage'}
							<span id="{$reco.theme.priceReductionId|escape:'htmlall':'UTF-8'}" class="{$reco.theme.priceReductionClass|escape:'htmlall':'UTF-8'}">-{$product.specific_prices.reduction * 100}%</span>
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
							<a rel="{$product.id_product|escape:'htmlall'}" {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; font-size: {$reco.theme.cartSize}px;  text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if} class="{$reco.theme.cartClass}" id="{$reco.theme.cartId}" href="{$link->getPageLink('cart',false, NULL, "add=1&amp;id_product={$product.id_product|intval}&amp;token={$static_token}", false)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Add to cart' mod='affinityitems'}" data-id-product="{$product.id_product|intval}">
								<span {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border: {$reco.theme.cartBorderSize}px solid {$reco.theme.cartBorderColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; {if !$reco.theme.cartBackgroundColorTransparent} background: {$reco.theme.cartBackgroundColor};{/if} font-size: {$reco.theme.cartSize}px;  text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if}>{l s='Add to cart' mod='affinityitems'}</span>
							</a>
							{/if}
							{else}
							{if $reco.theme.cartActivation}
							<a rel="{$product.id_product|escape:'htmlall'}" {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if} class="{$reco.theme.cartClass}" id="{$reco.theme.cartId}"  href="{$link->getPageLink('cart',false, NULL, 'add=1&amp;id_product={$product.id_product|intval}', false)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Add to cart' mod='affinityitems'}" data-id-product="{$product.id_product|intval}">
								<span {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border: {$reco.theme.cartBorderSize}px solid {$reco.theme.cartBorderColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important;{if !$reco.theme.cartBackgroundColorTransparent} background: {$reco.theme.cartBackgroundColor};{/if} font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if}>{l s='Add to cart' mod='affinityitems'}</span>
							</a>
							{/if}
							{/if}						
							{else}
							{if $reco.theme.cartActivation}
							<span {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important; font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if} class="{$reco.theme.cartClass} disabled" id="{$reco.theme.cartId}">
								<span {if $reco.theme.cartDisplayOptions} style="color: {$reco.theme.cartColor}; border: {$reco.theme.cartBorderSize}px solid {$reco.theme.cartBorderColor}; border-radius: {$reco.theme.cartBorderRoundedSize}px !important;{if !$reco.theme.cartBackgroundColorTransparent} background: {$reco.theme.cartBackgroundColor};{/if} font-size: {$reco.theme.cartSize}px; text-align: {$reco.theme.cartAlign}; line-height: {$reco.theme.cartLineHeight}px;" {/if}>{l s='Add to cart' mod='affinityitems'}</span>
							</span>
							{/if}
							{/if}
							{/if}
							{if $reco.theme.detailActivation}
							<a rel="{$product.id_product|escape:'htmlall'}" itemprop="url" {if $reco.theme.detailDisplayOptions} style="color: {$reco.theme.detailColor}; font-size: {$reco.theme.detailSize}px;" {/if} id="{$reco.theme.detailId}" class="{$reco.theme.detailClass}" href="{$product.link|escape:'html':'UTF-8'}" title="{l s='View' mod='affinityitems'}">
								<span>{l s='More' mod='affinityitems'}</span>
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

