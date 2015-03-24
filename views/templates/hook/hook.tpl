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

    {/literal}{if $trackingJs}{literal}

    var pageName = '{/literal}{$pageName}{literal}';

    var affinityItemsTrackPageView=function(t,e){"use strict";var n=function(t,e){"undefined"==typeof ga&&!function(t,e,n,o,a,c,i){t.GoogleAnalyticsObject=a,t[a]=t[a]||function(){(t[a].q=t[a].q||[]).push(arguments)},t[a].l=1*new Date,c=e.createElement(n),i=e.getElementsByTagName(n)[0],c.async=1,c.src=o,i.parentNode.insertBefore(c,i)}(window,document,"script","//www.google-analytics.com/analytics.js","ga"),ga("create","UA-57445738-1",{name:"affintyItemsTracker",cookieName:"_affintyItemsGa",cookieDomain:"auto"}),ga("affintyItemsTracker.set","location",window.location.protocol+"//"+window.location.host+"/"+window.location.host+window.location.pathname+window.location.search+window.location.hash),void 0===t&&(t="not-set"),void 0===e&&(e="not-set"),ga("affintyItemsTracker.send","pageview",{dimension1:t,dimension2:e})};document.addEventListener?document.addEventListener("DOMContentLoaded",function(){n(t,e)}):document.attachEvent?document.attachEvent("onreadystatechange",function(){"complete"==document.readyState&&n(t,e)}):console.log("[affintyItemsTrack] cannot attach to a document ready event")};

    affinityItemsTrackPageView(abtesting, pageName);

    {/literal}{/if}{literal}

    $(document).ready(function () {
       {/literal}
       {if $renderCategory != "" && !empty($renderCategory)}
       {literal}
        if ($("body").attr("id") == "category") {
            {/literal}
            {for $position=1 to 2}
            {literal}
            {/literal}{if isset($renderCategory[$position-1])}{literal}
            var renderCategory_{/literal}{$position}{literal} = $.trim('{/literal}{$renderCategory[$position-1]}{literal}');
            $("{/literal}{$hookCategoryConfiguration->recoSelectorCategory_{$position}}{literal}").first().{/literal}{$hookCategoryConfiguration->recoSelectorPositionCategory_{$position}}{literal}(renderCategory_{/literal}{$position}{literal});
            if ($(".aereco").length && $("{/literal}{$hookCategoryConfiguration->recoSelectorCategory_{$position}}{literal}").length) {
                $(".aereco").show();
            }
            {/literal}{/if}{literal}
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
            {/literal}{if isset($renderSearch[$position-1])}{literal}
            var renderSearch_{/literal}{$position}{literal} = $.trim('{/literal}{$renderSearch[$position-1]}{literal}');
            $("{/literal}{$hookSearchConfiguration->recoSelectorSearch_{$position}}{literal}").first().{/literal}{$hookSearchConfiguration->recoSelectorPositionSearch_{$position}}{literal}(renderSearch_{/literal}{$position}{literal});
            if ($(".aereco").length && $("{/literal}{$hookSearchConfiguration->recoSelectorSearch_{$position}}{literal}").length) {
                 $(".aereco").show();
            }
            {/literal}{/if}{literal}
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