	<div class="items-title">
		{l s='Theme editor' mod='affinityitems'}
		<span class="visit"><a href="{$baseUrl}?aeabtesting=A" target="_blank"><i class="fa fa-eye"></i> {l s='Display recommendation on your shop' mod='affinityitems'}</span></a>
	</div>
	<form action="#theme-editor" method="POST">
	<div class="items-theme-selector">
			<div class="items-register-theme items-left">
				<input type="text" class="items-new-theme-input" name="themeName" placeholder="Nom du thème">
				<input type="submit" value="Valider" class="items-button-plus">
			</div>
			<div class="items-theme-selector-content">
				<div class="items-left">
					<p>{l s='Theme' mod='affinityitems'} :</p><br>
				</div>
					<select name="themeId" id="themeSelector">
						{foreach from=$themeList item=theme}
						<option value="{$theme.id_theme}" {if $theme.id_theme == $themeSelected.themeId} selected {/if}>{$theme.name}</option>
						{/foreach}
					</select>
					<input type="submit" class="items-button-submit items-theme-cancel" onClick="location.reload();return false;" value="{l s='Cancel' mod='affinityitems'}">
					<input type="submit" value="{l s='Save' mod='affinityitems'}" class="items-button-submit">
					<input type="submit" id="registerTheme" value="{l s='Save as' mod='affinityitems'}" class="items-button-submit">
			</div>
			<div class="clear"></div>
		</div>
		<div class="preview">
			<div class="toolbox">
				<div class="background-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Background' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<fieldset>
						<legend>
							<input type="hidden" name="backgroundDisplayOptions" value="0">
							<input type="checkbox" value="1" name="backgroundDisplayOptions" {if $themeSelected.themeConfiguration.backgroundDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Background Activation' mod='affinityitems'}</span>
						</legend>
						<div class="items-conf items-left">
							<label>	{l s='Background color' mod='affinityitems'} :</label><br>
							<input name="backgroundColor" type="color" value="{$themeSelected.themeConfiguration.backgroundColor}"/>
						</div>
						<div class="items-conf items-right">
							<label>{l s='Transparent' mod='affinityitems'} :</label>
							<input name="backgroundColorTransparent" type="hidden" value="0">
							<input name="backgroundColorTransparent" type="checkbox" value="1" {if $themeSelected.themeConfiguration.backgroundColorTransparent} checked {/if}>
						</div>
						<div class="clear"></div>
						<div class="items-conf">
							<label>{l s='Border color' mod='affinityitems'} :</label><br>
							<input name="backgroundBorderColor" type="color" value="{$themeSelected.themeConfiguration.backgroundBorderColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Round border' mod='affinityitems'} :</label><br>
							<input name="backgroundBorderRoundedSize" type="number" value="{$themeSelected.themeConfiguration.backgroundBorderRoundedSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Border size' mod='affinityitems'} :</label><br>
							<input name="backgroundBorderSize" type="number" value="{$themeSelected.themeConfiguration.backgroundBorderSize}"/>
						</div>
					</fieldset>
					<fieldset>
						<legend>CSS products bloc div</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="backgroundProductsBlockId" type="text" value="{$themeSelected.themeConfiguration.backgroundProductsBlockId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="backgroundProductsBlockClass" type="text" value="{$themeSelected.themeConfiguration.backgroundProductsBlockClass}"/>
						</div>
					</fieldset>
					<fieldset>
						<legend>CSS content div</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="backgroundContentId" type="text" value="{$themeSelected.themeConfiguration.backgroundContentId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="backgroundContentClass" type="text" value="{$themeSelected.themeConfiguration.backgroundContentClass}"/>
						</div>
					</fieldset>
					<fieldset>				
						<legend>CSS list div (ul)</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="backgroundListId" type="text" value="{$themeSelected.themeConfiguration.backgroundListId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="backgroundListClass" type="text" value="{$themeSelected.themeConfiguration.backgroundListClass}"/>
						</div>
					</fieldset>
				</div>
				<div class="title-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Title' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<hr>
					<fieldset>
						<legend> 
							<input type="hidden" name="titleDisplayOptions" value="0">
							<input type="checkbox" value="1" name="titleDisplayOptions" {if $themeSelected.themeConfiguration.titleDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Title Activation' mod='affinityitems'}</span>
						</legend>					
						<div class="items-conf">
							<label>	{l s='Text color' mod='affinityitems'} :</label><br>
							<input name="titleColor" type="color" value="{$themeSelected.themeConfiguration.titleColor}"/>
						</div>
						<div class="items-conf items-left">
							<label>{l s='Background color' mod='affinityitems'} :</label><br>
							<input name="titleBackgroundColor" type="color" value="{$themeSelected.themeConfiguration.titleBackgroundColor}"/>
						</div>
						<div class="items-conf items-right">
							<label>{l s='Transparent' mod='affinityitems'} :</label> 
							<input name="titleBackgroundColorTransparent" type="hidden" value="0">
							<input name="titleBackgroundColorTransparent" type="checkbox" value="1" {if $themeSelected.themeConfiguration.titleBackgroundColorTransparent} checked {/if}>
						</div>
						<div class="clear"></div>
						<div class="items-conf">
							<label>{l s='Text size' mod='affinityitems'} (px) :</label><br>
							<input name="titleSize" type="number" value="{$themeSelected.themeConfiguration.titleSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Border color' mod='affinityitems'} :</label><br>
							<input name="titleBorderColor" type="color" value="{$themeSelected.themeConfiguration.titleBorderColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Round border' mod='affinityitems'} :</label><br>
							<input name="titleBorderRoundedSize" type="number" value="{$themeSelected.themeConfiguration.titleBorderRoundedSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Border size' mod='affinityitems'} :</label><br>
							<input name="titleBorderSize" type="number" value="{$themeSelected.themeConfiguration.titleBorderSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Text align' mod='affinityitems'} :</label><br>
							<select name="titleAlign">
								<option value="left" {if $themeSelected.themeConfiguration.titleAlign == "left"} selected {/if}>Left</option>
								<option value="center" {if $themeSelected.themeConfiguration.titleAlign == "center"} selected {/if}>Center</option>
								<option value="right" {if $themeSelected.themeConfiguration.titleAlign == "right"} selected {/if}>Right</option>
							</select> 						
						</div>
						<div class="items-conf">
							<label>{l s='Text Line height' mod='affinityitems'} (px) :</label><br>
							<input name="titleLineHeight" type="number" value="{$themeSelected.themeConfiguration.titleLineHeight}"/>
						</div>
					</fieldset>
					<fieldset>
						<legend>CSS {l s='Title' mod='affinityitems'} </legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="titleId" type="text"  value="{$themeSelected.themeConfiguration.titleId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="titleClass" type="text" value="{$themeSelected.themeConfiguration.titleClass}"/>
						</div>
					</fieldset>
				</div>
				<div class="product-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Product' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<hr>
					<fieldset>				
						<legend>
							<input type="hidden" name="productDisplayOptions" value="0">
							<input type="checkbox" value="1" name="productDisplayOptions" {if $themeSelected.themeConfiguration.productDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Product Activation' mod='affinityitems'}</span>
						</legend>
						<div class="items-conf items-left">
							<label>{l s='Background color' mod='affinityitems'} :</label><br>
							<input name="productBackgroundColor" type="color" value="{$themeSelected.themeConfiguration.productBackgroundColor}"/>
						</div>
						<div class="items-conf items-right">
							<label>{l s='Transparent' mod='affinityitems'}</label>
							<input name="productBackgroundColorTransparent" type="hidden" value="0">
							<input name="productBackgroundColorTransparent" type="checkbox" value="1" {if $themeSelected.themeConfiguration.productBackgroundColorTransparent} checked {/if}>
						</div>
						<div class="clear"></div>
						<div class="items-conf">
							<label>{l s='Border color' mod='affinityitems'} :</label><br>
							<input name="productBorderColor" type="color" value="{$themeSelected.themeConfiguration.productBorderColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Round border' mod='affinityitems'} :</label><br>
							<input name="productBorderRoundedSize" type="number" value="{$themeSelected.themeConfiguration.productBorderRoundedSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Border size' mod='affinityitems'} :</label><br>
							<input name="productBorderSize" type="number" value="{$themeSelected.themeConfiguration.productBorderSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Zone height' mod='affinityitems'} (li) :</label><br>
							<input name="productHeight" type="number" value="{$themeSelected.themeConfiguration.productHeight}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Zone width' mod='affinityitems'} (li) :</label><br>
							<input name="productWidth" type="number" value="{$themeSelected.themeConfiguration.productWidth}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Product number on a line' mod='affinityitems'} :</label><br>
							<input name="productNumberOnLine" type="number" value="{$themeSelected.themeConfiguration.productNumberOnLine}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Margin right' mod='affinityitems'} (px) :</label><br>
							<input name="productMarginRight" type="number" value="{$themeSelected.themeConfiguration.productMarginRight}"/>
						</div>
					</fieldset>
					<fieldset>				
						<legend>{l s='Product element' mod='affinityitems'} (li)</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="productId" type="text"  value="{$themeSelected.themeConfiguration.productId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="productClass" type="text" value="{$themeSelected.themeConfiguration.productClass}"/>
						</div>
					</fieldset>
					{if $version >= 16}
					<fieldset>				
						<legend>CSS {l s='product container' mod='affinityitems'}</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="productContainerId" type="text"  value="{$themeSelected.themeConfiguration.productContainerId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="productContainerClass" type="text" value="{$themeSelected.themeConfiguration.productContainerClass}"/>
						</div>
					</fieldset>
					<fieldset>				
						<legend>CSS {l s='product left block' mod='affinityitems'}</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="productLeftBlockId" type="text"  value="{$themeSelected.themeConfiguration.productLeftBlockId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="productLeftBlockClass" type="text" value="{$themeSelected.themeConfiguration.productLeftBlockClass}"/>
						</div>
					</fieldset>
					<fieldset>				
						<legend>CSS {l s='product right block' mod='affinityitems'}</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="productRightBlockId" type="text"  value="{$themeSelected.themeConfiguration.productRightBlockId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="productRightBlockClass" type="text" value="{$themeSelected.themeConfiguration.productRightBlockClass}"/>
						</div>
					</fieldset>
					{/if}
				</div>
				<div class="productTitle-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Product title' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<hr>
					<fieldset>
						<legend>
							<input type="hidden" name="productTitleDisplayOptions" value="0">
							<input type="checkbox" value="1" name="productTitleDisplayOptions" {if $themeSelected.themeConfiguration.productTitleDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Product title Activation' mod='affinityitems'}</span>
						</legend>
						<div class="items-conf">
							<label>{l s='Product title color' mod='affinityitems'} :</label><br>
							<input name="productTitleColor" type="color" value="{$themeSelected.themeConfiguration.productTitleColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Product text size' mod='affinityitems'} (px) :</label><br>
							<input name="productTitleSize" type="number" value="{$themeSelected.themeConfiguration.productTitleSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Product title height' mod='affinityitems'} (px) :</label><br>
							<input name="productTitleHeight" type="number" value="{$themeSelected.themeConfiguration.productTitleHeight}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Product title align' mod='affinityitems'} :</label><br>
							<select name="productTitleAlign">
								<option value="left" {if $themeSelected.themeConfiguration.productTitleAlign == "left"} selected {/if}>Left</option>
								<option value="center" {if $themeSelected.themeConfiguration.productTitleAlign == "center"} selected {/if}>Center</option>
								<option value="right" {if $themeSelected.themeConfiguration.productTitleAlign == "right"} selected {/if}>Right</option>
							</select>
						</div>
						<div class="items-conf">
							<label>{l s='Product title Line height' mod='affinityitems'} (px) :</label><br>
							<input name="productTitleLineHeight" type="number" value="{$themeSelected.themeConfiguration.productTitleLineHeight}"/>
						</div>
					</fieldset>
					<fieldset>				
						<legend>CSS {l s='product title' mod='affinityitems'}</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="productTitleId" type="text"  value="{$themeSelected.themeConfiguration.productTitleId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="productTitleClass" type="text" value="{$themeSelected.themeConfiguration.productTitleClass}"/>
						</div>
					</fieldset>
					{if $version >= 16}
					<fieldset>				
						<legend>CSS {l s='product link title' mod='affinityitems'}</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="productLinkTitleId" type="text"  value="{$themeSelected.themeConfiguration.productLinkTitleId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="productLinkTitleClass" type="text" value="{$themeSelected.themeConfiguration.productLinkTitleClass}"/>
						</div>
					</fieldset>
					{/if}		
				</div>
				<div class="description-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Description' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<hr>
					<fieldset>				
						<legend>
							<input type="hidden" name="productDescriptionDisplayOptions" value="0">
							<input type="checkbox" value="1" name="productDescriptionDisplayOptions" {if $themeSelected.themeConfiguration.productDescriptionDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Product Description Activation' mod='affinityitems'}</span>
						</legend>
						<div class="items-conf">
							<label>{l s='Text color' mod='affinityitems'} :</label><br>
							<input name="productDescriptionColor" type="color" value="{$themeSelected.themeConfiguration.productDescriptionColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Text size' mod='affinityitems'} (px) :</label><br>
							<input name="productDescriptionSize" type="number" value="{$themeSelected.themeConfiguration.productDescriptionSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Zone height' mod='affinityitems'} (px) :</label><br>
							<input name="productDescriptionHeight" type="number" value="{$themeSelected.themeConfiguration.productDescriptionHeight}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Description title align' mod='affinityitems'} :</label><br>
							<select name="productDescriptionAlign">
								<option value="left" {if $themeSelected.themeConfiguration.productDescriptionAlign == "left"} selected {/if}>Left</option>
								<option value="center" {if $themeSelected.themeConfiguration.productDescriptionAlign == "center"} selected {/if}>Center</option>
								<option value="right" {if $themeSelected.themeConfiguration.productDescriptionAlign == "right"} selected {/if}>Right</option>
							</select>
						</div>
						<div class="items-conf">
							<label>{l s='Description title Line height' mod='affinityitems'} (px) :</label><br>
							<input name="productDescriptionLineHeight" type="number" value="{$themeSelected.themeConfiguration.productDescriptionLineHeight}"/>
						</div>
					</fieldset>
					<fieldset>				
						<legend>CSS {l s='product description' mod='affinityitems'}</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="productDescriptionId" type="text"  value="{$themeSelected.themeConfiguration.productDescriptionId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="productDescriptionClass" type="text" value="{$themeSelected.themeConfiguration.productDescriptionClass}"/>
						</div>
					</fieldset>
				</div>
				<div class="image-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Picture' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<hr>
					<fieldset>
						<legend>
							<input type="hidden" name="pictureDisplayOptions" value="0">
							<input type="checkbox" value="1" name="pictureDisplayOptions" {if $themeSelected.themeConfiguration.pictureDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Picture Activation' mod='affinityitems'}</span>
						</legend>
						<div class="items-conf">
							<label>{l s='Border color' mod='affinityitems'} :</label><br>
							<input name="pictureBorderColor" type="color" value="{$themeSelected.themeConfiguration.pictureBorderColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Round border' mod='affinityitems'} :</label><br>
							<input name="pictureBorderRoundedSize" type="number" value="{$themeSelected.themeConfiguration.pictureBorderRoundedSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Border size' mod='affinityitems'} :</label><br>
							<input name="pictureBorderSize" type="number" value="{$themeSelected.themeConfiguration.pictureBorderSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Picture height' mod='affinityitems'} :</label><br>
							<input name="pictureHeight" type="number" value="{$themeSelected.themeConfiguration.pictureHeight}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Picture width' mod='affinityitems'} :</label><br>
							<input name="pictureWidth" type="number" value="{$themeSelected.themeConfiguration.pictureWidth}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Picture resolution' mod='affinityitems'} :</label><br>
							<select name="pictureResolution">
								{foreach from=$imgSizeList item=size}
								<option value="{$size.name|escape:'htmlall':'UTF-8'}" {if $size.name == $themeSelected.themeConfiguration.pictureResolution} selected {/if}>{$size.name}</option>
								{/foreach}
							</select> 
						</div>
					</fieldset>
					<fieldset>
						<legend>CSS {l s='picture link' mod='affinityitems'} </legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="pictureLinkId" type="text"  value="{$themeSelected.themeConfiguration.pictureLinkId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="pictureLinkClass" type="text" value="{$themeSelected.themeConfiguration.pictureLinkClass}"/>
						</div>
					</fieldset>
					<fieldset>
						<legend>CSS {l s='picture' mod='affinityitems'}</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="pictureId" type="text"  value="{$themeSelected.themeConfiguration.pictureId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="pictureClass" type="text" value="{$themeSelected.themeConfiguration.pictureClass}"/>
						</div>
					</fieldset>
				</div>
				<div class="price-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Price' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<hr>
					<fieldset>
						<legend>
							<input type="hidden" name="priceDisplayOptions" value="0">
							<input type="checkbox" value="1" name="priceDisplayOptions" {if $themeSelected.themeConfiguration.priceDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Price Activation' mod='affinityitems'}</span>
						</legend>
						<div class="items-conf">
							<label>{l s='Text color' mod='affinityitems'} :</label><br>
							<input name="priceColor" type="color" value="{$themeSelected.themeConfiguration.priceColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Text size' mod='affinityitems'} (px) :</label><br>
							<input name="priceSize" type="number" value="{$themeSelected.themeConfiguration.priceSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Zone height' mod='affinityitems'} (px) :</label><br>
							<input name="priceHeight" type="number" value="{$themeSelected.themeConfiguration.priceHeight}"/>
						</div>
					</fieldset>

					<fieldset>
						<legend>CSS price container</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="priceContainerId" type="text"  value="{$themeSelected.themeConfiguration.priceContainerId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="priceContainerClass" type="text" value="{$themeSelected.themeConfiguration.priceContainerClass}"/>
						</div>
					</fieldset>
					<fieldset>
						<legend>CSS price</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="priceId" type="text"  value="{$themeSelected.themeConfiguration.priceId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="priceClass" type="text" value="{$themeSelected.themeConfiguration.priceClass}"/>
						</div>
					</fieldset>
					{if $version >= 16}
					<fieldset>				
						<legend>CSS old price</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="oldPriceId" type="text"  value="{$themeSelected.themeConfiguration.oldPriceId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="oldPriceClass" type="text" value="{$themeSelected.themeConfiguration.oldPriceClass}"/>
						</div>
					</fieldset>
					<fieldset>				
						<legend>CSS price percent reduction</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="priceReductionId" type="text"  value="{$themeSelected.themeConfiguration.priceReductionId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="priceReductionClass" type="text" value="{$themeSelected.themeConfiguration.priceReductionClass}"/>
						</div>
					</fieldset>
					{/if}
				</div>
				<div class="cart-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Cart' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<fieldset>
						<legend>
							<input type="hidden" name="cartDisplayOptions" value="0">
							<input type="checkbox" value="1" name="cartDisplayOptions" {if $themeSelected.themeConfiguration.cartDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Cart Activation' mod='affinityitems'}</span>
						</legend>
						<div class="items-conf">
							<label>{l s='Text color' mod='affinityitems'} :</label><br>
							<input name="cartColor" type="color" value="{$themeSelected.themeConfiguration.cartColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Border size' mod='affinityitems'} :</label><br>
							<input name="cartBorderSize" type="number" value="{$themeSelected.themeConfiguration.cartBorderSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Text size' mod='affinityitems'} (px) :</label><br>
							<input name="cartSize" type="number" value="{$themeSelected.themeConfiguration.cartSize}"/>
						</div>
						<div class="items-conf items-left">
							<label>{l s='Background color' mod='affinityitems'} :</label><br>
							<input name="cartBackgroundColor" type="color" value="{$themeSelected.themeConfiguration.cartBackgroundColor}"/>
						</div>
						<div class="items-conf items-right">
							<label>{l s='Transparent' mod='affinityitems'} :</label>
							<input name="cartBackgroundColorTransparent" type="hidden" value="0">
							<input name="cartBackgroundColorTransparent" type="checkbox" value="1" {if $themeSelected.themeConfiguration.cartBackgroundColorTransparent} checked {/if}>
						</div>
						<div class="clear"></div>
						<div class="items-conf">
							<label>{l s='Border color' mod='affinityitems'} :</label><br>
							<input name="cartBorderColor" type="color" value="{$themeSelected.themeConfiguration.cartBorderColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Round border size' mod='affinityitems'} :</label><br>
							<input name="cartBorderRoundedSize" type="number" value="{$themeSelected.themeConfiguration.cartBorderRoundedSize}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Cart text align' mod='affinityitems'} :</label><br>
							<select name="cartAlign">
								<option value="left" {if $themeSelected.themeConfiguration.cartAlign == "left"} selected {/if}>Left</option>
								<option value="center" {if $themeSelected.themeConfiguration.cartAlign == "center"} selected {/if}>Center</option>
								<option value="right" {if $themeSelected.themeConfiguration.cartAlign == "right"} selected {/if}>Right</option>
							</select> 
						</div>
						<div class="items-conf">
							<label>{l s='Cart text line height' mod='affinityitems'} (px) :</label><br>
							<input name="cartLineHeight" type="number" value="{$themeSelected.themeConfiguration.cartLineHeight}"/>
						</div>
					</fieldset>
					<fieldset>
						<legend>CSS price container</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="cartId" type="text" value="{$themeSelected.themeConfiguration.cartId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="cartClass" type="text" value="{$themeSelected.themeConfiguration.cartClass}"/>
						</div>
					</fieldset>
				</div>
				<div class="detail-toolbox toolboxarea" style="display:none">
					<div class="items-config-title">
						{l s='Detail' mod='affinityitems'}
						<span toolbox="default" class="toolbox-button back">&#10550;</span>
						<hr>
					</div>
					<fieldset>
						<legend>
							<input type="hidden" name="detailDisplayOptions" value="0">
							<input type="checkbox" value="1" name="detailDisplayOptions" {if $themeSelected.themeConfiguration.detailDisplayOptions == "1"} checked="checked" {/if}>
							<span class="items-theme-zone-activation">{l s='Detail Activation' mod='affinityitems'}</span>
						</legend>
						<div class="items-conf">
							<label>{l s='Text color' mod='affinityitems'} :</label><br>
							<input name="detailColor" type="color" value="{$themeSelected.themeConfiguration.detailColor}"/>
						</div>
						<div class="items-conf">
							<label>{l s='Text size' mod='affinityitems'} (px) : (px) :</label><br>
							<input name="detailSize" type="number" value="{$themeSelected.themeConfiguration.detailSize}"/>
						</div>
					</fieldset>
					<fieldset>
						<legend>CSS product detail</legend>
						<div class="items-conf">
							<label>id :</label><br>
							<input name="detailId" type="text"  value="{$themeSelected.themeConfiguration.detailId}"/>
						</div>
						<div class="items-conf">
							<label>class :</label><br>
							<input name="detailClass" type="text" value="{$themeSelected.themeConfiguration.detailClass}"/>
						</div>
					</fieldset>
				</div>
				<div class="default-toolbox toolboxarea" style="display:inherit">
					<div class="title">
						{l s='General' mod='affinityitems'}
						<hr>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type="checkbox" name="backgroundActivation" checked="true" disabled="true">
						</div>
						<button class="toolbox-button" toolbox="background" type="button">{l s='Background' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type='hidden' value='0' name='titleActivation'>
							<input type="checkbox" name="titleActivation" value='1'
							{if $themeSelected.themeConfiguration.titleActivation == "1"} checked="true" {/if}>
						</div>
						<button class="toolbox-button" toolbox="title" type="button">{l s='Title' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type="checkbox" name="productActivation" checked="true" disabled="true">
						</div>
						<button class="toolbox-button" toolbox="product" type="button">{l s='Product' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type='hidden' value='0' name='productTitleActivation'>
							<input type="checkbox" name="productTitleActivation" value='1' 
							{if $themeSelected.themeConfiguration.productTitleActivation == "1"} checked="true" {/if}>
						</div>
						<button class="toolbox-button" toolbox="productTitle" type="button">{l s='Title product' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type='hidden' value='0' name='productDescriptionActivation'>
							<input type="checkbox" name="productDescriptionActivation" value="1"
							{if $themeSelected.themeConfiguration.productDescriptionActivation == "1"} checked="true" {/if}>
						</div>
						<button class="toolbox-button" toolbox="description" type="button">{l s='Description' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type="checkbox" name="pictureActivation" checked="true" disabled="true">
						</div>
						<button class="toolbox-button" toolbox="image" type="button">{l s='Picture' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type='hidden' value='0' name='priceActivation'>
							<input type="checkbox" name="priceActivation" value="1"  
							{if $themeSelected.themeConfiguration.priceActivation == "1"} checked="true" {/if}>
						</div>
						<button class="toolbox-button" toolbox="price" type="button">{l s='Price' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type='hidden' value='0' name='cartActivation'>
							<input type="checkbox" name="cartActivation" value="1" 
							{if $themeSelected.themeConfiguration.cartActivation == "1"} checked="true" {/if}>
						</div>
						<button class="toolbox-button" toolbox="cart" type="button">{l s='Cart' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
					<div class="items-conf">
						<div class="onoffswitch">
							<input type='hidden' value='0' name='detailActivation'>
							<input type="checkbox" name="detailActivation" value="1"
							{if $themeSelected.themeConfiguration.detailActivation == "1"} checked="true" {/if}>
						</div>
						<button class="toolbox-button" toolbox="detail" type="button">{l s='Detail' mod='affinityitems'} <span class="arrow">></span></button>
					</div>
				</div>
			</div>
			<div class="preview-area">
				{include file="../hook/{$version}/hrecommendation.tpl"}
			</div>
		</div>
	<div class="clear"></div>
</form>
