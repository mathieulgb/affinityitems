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
{literal}
<script>
    var abtesting = '{/literal}{$abtesting}{literal}';
    $(document).ready(function () {
       {/literal}
       {if $renderCategory != "" && !empty($renderCategory)}
       {literal}
        if ($("body").attr("id") == "category") {
            {/literal}
            {for $position=1 to 2}
            {literal}
            var renderCategory_{/literal}{$position}{literal} = $.trim('{/literal}{$renderCategory[$position-1]}{literal}');
            $("{/literal}{$hookCategoryConfiguration->recoSelectorCategory_{$position}}{literal}").first().{/literal}{$hookCategoryConfiguration->recoSelectorPositionCategory_{$position}}{literal}(renderCategory_{/literal}{$position}{literal});
            if ($(".aereco").length && $("{/literal}{$hookCategoryConfiguration->recoSelectorCategory_{$position}}{literal}").length) {
                $(".aereco").show();
            }
            {/literal}
            {/for}
            {literal}
        }
        {/literal}
        {/if}
        {literal}
       {/literal}
       {if $renderSearch != "" && !empty($renderSearch)}
       {literal}
        if ($("body").attr("id") == "search") {
            {/literal}
            {for $position=1 to 2}
            {literal}
            var renderSearch_{/literal}{$position}{literal} = $.trim('{/literal}{$renderSearch[$position-1]}{literal}');
            $("{/literal}{$hookSearchConfiguration->recoSelectorSearch_{$position}}{literal}").first().{/literal}{$hookSearchConfiguration->recoSelectorPositionSearch_{$position}}{literal}(renderSearch_{/literal}{$position}{literal});
            if ($(".aereco").length && $("{/literal}{$hookSearchConfiguration->recoSelectorSearch_{$position}}{literal}").length) {
                 $(".aereco").show();
             }
            {/literal}
            {/for}
            {literal}
        }
        {/literal}
        {/if}
        {literal}
        $('.ae-area a').on('click', function() {
            aenow = new Date().getTime();
            createCookie('aelastreco', (aenow+"."+$(this).parents(".ae-area").attr("class").split(" ")[1].split("-")[1]+"."+$(this).attr("rel")), 1);
        });
    });
    {/literal}{if isset($categoryId) && $categoryId != ''}{literal}
    var categoryId = {/literal}{$categoryId}{literal};
    {/literal}{/if}{literal}
</script>
<style type="text/css">
      {/literal}{$additionalCss|escape:"htmlall":"UTF-8"}{literal}
</style>
{/literal}