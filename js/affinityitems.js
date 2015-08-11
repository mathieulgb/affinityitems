/**
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
*/

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function deleteCookie(name) {
    document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT; path=/';
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function reindexArray(array) {
	var result = [];
	for( var key in array )
		if(array[key] !== null)
			result.push( array[key] );
	return result;
}

function postAction(action, object) {
	if(!object.recoType) {
		if(object.productId) {
			$.ajax({
				type: 'POST',
				url: baseDir + 'modules/affinityitems/ajax/action.php',
				data: {productId: object.productId, action: action },
				async:true,
				dataType: 'json',
				complete: function(e,t,n) {}
			});
		} else if(object.categoryId) {
			$.ajax({
				type: 'POST',
				url: baseDir + 'modules/affinityitems/ajax/action.php',
				data: {categoryId: object.categoryId, action: action },
				async:true,
				dataType: 'json',
				complete: function(e,t,n) {}
			});
		}
	} else {
		$.ajax({
			type: 'POST',
			url: baseDir + 'modules/affinityitems/ajax/action.php',
			data: {recoType : object.recoType, productId: object.productId, action: action },
			async:true,
			dataType: 'json',
			complete: function(e,t,n) {}
		});
		deleteCookie('aelastreco');
	}
}

function rightClickOnRecommendation(rightClickTime, recoType, productId) {
	var aeRightClickReco = [];
	if(readCookie('aeRightClickReco') !== null) {
		aeRightClickReco = JSON.parse(readCookie('aeRightClickReco'));
		deleteCookie('aeRightClickReco');
	}
	aeRightClickReco.push({rightClickTime : rightClickTime, recoType : recoType, productId : productId});
	createCookie('aeRightClickReco', JSON.stringify(aeRightClickReco), 1);
}

$(document).ready(function() {
	if(readCookie("aesync") != "true") {
		$.ajax({
			type: 'POST',
			url: baseDir + 'modules/affinityitems/ajax/synchronize.php',
			data: {"synchronize" : true},
			async:true,
			dataType: 'json',
			complete: function(e,t,n) {}
		});
		createCookie("aesync", "true", false);
	}

	/*	
		Read && Rebound
	*/

	var paetimestamp = readCookie('paetimestamp');
	var caetimestamp = readCookie('caetimestamp');

	var aelastreco = readCookie('aelastreco');

	var aenow = new Date().getTime();

	if($('#product_page_product_id').val()){
		var aetimer = setInterval((function(){
			clearInterval(aetimer);
			postAction("read", {productId : $('#product_page_product_id').val()});
		}), 4000);
		createCookie('paetimestamp', (aenow+"."+$('#product_page_product_id').val()), 1);
	}

	if(paetimestamp){
		paetimestamp = paetimestamp.split('.');
		var diff = aenow - paetimestamp[0];
		if(diff < 4000) {
			postAction("rebound", {productId : paetimestamp[1]});
		}
	}

	if(document.body.id == "category") {
		var aetimer = setInterval((function(){
			clearInterval(aetimer);
			postAction("readCategory", {categoryId : categoryId});
		}), 4000);
		createCookie('caetimestamp', (aenow+"."+categoryId), 1);
	}

	if(caetimestamp) {
		caetimestamp = caetimestamp.split('.');
		var diff = aenow - caetimestamp[0];
		if(diff < 4000) {
			postAction("reboundCategory", {categoryId : caetimestamp[1]});
		}
	}

	/*	
		Click on recommendations
	*/

	if(aelastreco) {
		aelastreco = aelastreco.split('.');
		postAction("trackRecoClick", {recoType : aelastreco[1], productId : aelastreco[2]});
	}

});