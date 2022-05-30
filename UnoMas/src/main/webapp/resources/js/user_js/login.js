function memberCk(){
	if($("#id").val() == "") {
		$("#cir_text").text("아이디를 입력하세요."); 
		$("#id").focus();
		return false;
	};
	
	if($("#pass").val() == "") {
		$("#cir_text").text("비밀번호를 입력하세요.");
		$("#pass").focus();
		return false;
	};
	
	$.ajax({
		async: true,
		type: "POST",
		url: "login",
		data: {
			'user_id': $("#id").val(), 
			'user_pass': $("#pass").val()
		},
		success: function(result) {
			if(result != "1") {
				$("#cir_text").html("잘못된 아이디 혹은 비밀번호입니다.");
			} else {
				window.location.replace(document.referrer);
			}
		},
		error: function(error) {
			alert("실패");
		}
	}); 
	
	var key = getCookie("key");
	$("input[name='user_id']").val(key);
	
	// 이전에 이미 아이디 저장
	if($("#id").val() != "") {
		$("#check_save").attr("checked",true);
	}
	// 체크박스 변화o
	$("#check_save").change(function(){
		if($("check_save").is(":checked")){
			setCookie("key",$("#id").val(),7);
		}else {
			deleteCookie("key");
		}
	});
	
	// 아이디저장 이미 체크한 후 아이디 입력
	$("#id").keyup(function(){
		if($("#check_save").is(":checked")){
			setCookie("key",$("#id").val(),7);
		}
	});
	
	// 쿠키 저장
	function setCookie(cookieName,value,exdays){
		var exdate = new Date();
		exdate.setDate(exdate.getDate()+exdays);
		var cookieValue = escape(value)
			+ ((exdays==null)? "":";expires="+exdate.toGMTString());
		document.cookie = cookieName + "=" + cookieValue;
	}
	
	// 쿠키 삭제
	function deleteCookie(cookieName) {
		var expireDate = new Date();
		expireDate.setDate(expireDate.getDate()-1);
		document.cookie = cookieName+"="+";expires="
			+expireDate.toGMTString();
	}
	
	//쿠키 가져오기
	function getCookie(cookieName){
		cookieName = cookieName +'=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cookieName);
		var cookieValue='';
		
		if(start != -1){
			start += cookieName.length;
			var end = cookieData.indexOf(';',start);
			if(end == -1)
				end = cookieData.length;
		console.log("end위치 : "+end);
			cookieValue = cookieData.substring(start,end);
		}
		return unescape(cookieValue);
	}
	
}