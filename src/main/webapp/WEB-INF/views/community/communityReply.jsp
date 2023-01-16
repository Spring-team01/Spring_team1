<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setBundle basename="i18n/board" />

<!DOCTYPE html>
<html>

<style>
 .dropbtn {
  background-color: #f9f9f9;
  color: white;
  padding: 0px;
  font-size: 16px;
  border: none;
  cursor: pointer;
}

.dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-content {
  display: none;
  position: absolute;
  background-color: white;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 1;
}

.dropdown-content a {
  color: black;
  padding: 0px 0px;
  text-decoration: none;
  display: block;
}

.dropdown-content a:hover {background-color: #f1f1f1}

.dropdown:hover .dropdown-content {
  display: block;
}

.dropdown:hover .dropbtn {
  background-color: #3e8e41;
}
</style>

<script>
	function writeReplyComment(i) {
		let replyContent= $("#writeReReply").val();
		let communityBoardId= $("#communityBoardId").val();
		let userId = $("#userId").val();
		
		$.ajax({
			url : "/myapp/community/writereplycomment/",
			type : "POST",
			datatype : "html",
			data : {communityCommentMasterNumber : i, communityCommentContent : replyContent, 
				communityBoardId : communityBoardId, userId : userId},
			success : function(data) {
				if(data==0) {
		           alert("댓글 작성에 실패하였습니다");
		         } else if(data==1) {
		          alert("댓글 작성 완료!");       	
		          location.reload();
		       }
			}
		});
	}
	
	
	function deleteReReplyComment(i){
		let communityBoardId= $("#communityBoardId").val();
		let communityCommentReplyNumber = $("#communityCommentReplyNumber").val();
		let communityCommentMasterNumber =$("#communityCommentMasterNumber").val();
		
		$.ajax({
			url : "/myapp/community/replycomment/delete/",
			type : "POST",
			data : {communityCommentMasterNumber : communityCommentMasterNumber , communityBoardId : communityBoardId, communityCommentReplyNumber : communityCommentReplyNumber},
			success : function(data){
				if(data==0) {
			           alert("댓글 삭제 실패");
			         } else if(data==1) {
			          alert("댓글 삭제 완료!");
			          location.reload();
			       }
			}
		});
		
	}
	
	
	
</script>


<body>
	<!-- Comments section-->
	<section class="mb-5">
		<div class="card bg-light">
			<div class="card-body">
				<c:forEach var="replyCommentList" items="${replyCommentList}">

					<div class="d-flex mb-3 ml-5">
						<!-- Parent comment-->
						<div class="flex-shrink-0 fix-comment-hidden">
							<img class="rounded-circle" src='<c:url value="/admin/userdetail/userfile/${replyCommentList.userFileId}"/>' alt="..." style="width: 50px; height: 50px;" />
						</div>
						<div class="ms-3 fix-comment-hidden">
							<div class="fw-bold">${replyCommentList.userName}</div>
							${replyCommentList.communityCommentContent}
						</div>
						<div class="ms-auto">
							<c:set var="id" value="${sessionUserId}" />
							<c:if test="${id eq commentList.userId}">
								<input id="deleteReReplyButton${commentList.communityCommentMasterNumber}" 
								type="button" onclick="deleteReReplyComment(${commentList.communityCommentMasterNumber})" 
								class="btn btn-sm btn-dark shadow" value="대댓글 삭제">
								<input type="hidden" id="communityCommentReplyNumber" name="communityCommentReplyNumber" 
								value="${replyCommentList.communityCommentReplyNumber}">
								<input type="hidden" id="communityCommentMasterNumber" name="communityCommentMasterNumber" 
								value="${replyCommentList.communityCommentMasterNumber}">
							</c:if>
						</div>
							<c:if test="${sessionScope.userId ne commentList.userId}">	
								<div class="dropdown"> 
									<img src='<c:url value="/images/threedots.svg"/>' class="dropbtn">
									<div class="dropdown-content">
									<a href="">신고하기</a>
									</div>
								</div>
							</c:if>
						 </div>
				</c:forEach>


				<!-- Comment form-->
				<form class="mb-4">
					<textarea id="writeReReply" class="form-control" rows="3" placeholder="답글 작성하기"></textarea>
					<input id="replyButton${commentList.communityCommentMasterNumber}" type="submit" onclick="writeReplyComment(${communityCommentMasterNumber})" class="btn btn-sm btn-dark shadow" value="댓글 작성"> <input type="hidden" name="communityCommentMasterNumber" value="${communityCommentMasterNumber}">
				</form>
			</div>
		</div>
	</section>
</body>