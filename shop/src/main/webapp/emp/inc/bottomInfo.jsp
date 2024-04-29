<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<head>
	<meta charset="UTF-8">
	<title></title>
	<style>
	.btb{
	text-align:left
	}
	
	.btd1{
	padding-left: 9px;
	padding-top: 5px;
	color:#DCDCDC;
	font-size:12px;
	}
	.btd2{
	padding-left: 9px;
	color:#DCDCDC;
	font-size:12px;
	}
	
	.btm{
	text-decoration: none;
	color:white;
	font-size: 14px;
	padding:10px 12px;
	padding-bottom:8px;
	}
	</style>
</head>

<div> 	
	<table class="btb" style="background-color: #696969; color:white; width:100%; height:88px; magin-top:3px;" >
		<tr>
			<th rowspan="3" style="text-align: center; width:5%; vertical-align: middle; padding:0px 0px; padding-bottom:0px;">
				<a href="/shop/goods/goodsList.jsp"><img src="/shop/upload/sosom.png" style="width:60px;"></a>
			</th>
			<th colspan="3" style="padding-top:3px; border-bottom: 1px solid"> 
				<div style="display:flex;">
				<a href="/shop/goods/goodsList.jsp" class="btm"> 홈 </a>
<!-- 				회사소개 | 이용약관 | 개인정보처리방침 |  이용안내  -->
				 <a href="#" class="btm" onclick="showAlert('회사소개')"> 회사소개 </a>
                        <a href="" class="btm" onclick="showAlert('이용약관')"> 이용약관 </a>
                        <a href="" class="btm" onclick="showAlert('개인정보처리방침')"> 개인정보처리방침 </a>
                        <a href="" class="btm" onclick="showAlert('이용안내')"> 이용안내 </a>
				</div>				
			</th>
		</tr>
		<tr>
			<td class="btd1"> 법인명 : SOSOM </td>
			<td class="btd1"> 대표자(성명) : 조인환</td>
			<td class="btd1"> 입금계좌 : 신한은행 123-456-678901</td>		
		</tr>
		<tr>
			<td class="btd2" style="padding-bottom:10px;"> 고객센터 : 010-0000-0000 </td>
			<td class="btd2" style="padding-bottom:10px;"> 팩스 : 02-00000-0000</td>
			<td class="btd2" style="padding-bottom:10px;"> 주소 : Gasan digital 2-ro, Geumcheon-gu, Seoul, Republic of Korea </td>
		</tr>
	</table>
	  <script>
        function showAlert() {
            alert('구현되지 않았습니다');
        }
    </script>
</div>
