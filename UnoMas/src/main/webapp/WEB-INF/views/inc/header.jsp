<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
 <!-- 로딩화면 동그라미 -->
    <div id="preloder">
        <div class="loader"></div>
    </div>
    
    <header class="headerSection">
    	<div id="headerTop" class="headerTop"> <!-- 헤더 맨위쪽 링크 -->
    		<ul class="listMenu">
    			<li class="menu menuLogin">
    				<a href="login" class="linkMenu">로그인</a>
    			</li>
    			<li class="menu menuJoin">
    				<a href="register" class="linkMenu">회원가입</a>
    			</li>
    			<li class="menu CS">
    				<a href="faq" class="linkMenu">고객센터</a>
    			</li>
    		</ul>
    	</div>
    	 <div class="container">
            <div class="inner-header">
                <div class="row">
                    <div class="col-lg-2 col-md-2">
                        <div class="logo">
                            <a href="index">
                                <img src="${path}/resources/img/logo.jpg" alt="로고";>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-7 col-md-7">
                        <div class="advanced-search">
                            <div class="input-group">
                                <input type="text" placeholder="검색어를 입력해주세요.">
                                <button type="button"><i class="ti-search"></i></button>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 text-right col-md-3">
                        <ul class="nav-right">
                            <li class="cart-icon">
                                <a href="shopping-cart">
                                    <i class="icon_bag_alt"></i>
                                </a>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="nav-item">
            <div class="container">
                <div class="nav-depart">
                    <div class="depart-btn">
                        <i class="ti-menu"></i>
                        <span>전체 카테고리</span>
                        <ul class="depart-hover">
                            <li><a href="#">여성의류</a></li>
                            <li><a href="#">남성의류</a></li>
                            <li><a href="#">언더웨어</a></li>
                            <li><a href="#">유아용의류</a></li>
                            <li><a href="#">브랜드</a></li>
                            <li><a href="#">악세사리/신발</a></li>
                            <li><a href="#">명품의류</a></li>
                        </ul>
                    </div>
                </div>
                <nav class="nav-menu mobile-menu">
                    <ul>
                        <li><a href="shop">신상품</a></li>
                        <li><a href="shop">특가</a></li>
                        <li><a href="shop">공동구매</a>
                            <ul class="dropdown">
                                <li><a href="#">Men's</a></li>
                                <li><a href="#">Women's</a></li>
                                <li><a href="#">Kid's</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>