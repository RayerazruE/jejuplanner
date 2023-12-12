<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">

<!-- 타이틀 -->
<title>제주도 여행 플래너(테스트)</title>
<link rel="shortcut icon" href="../resources/image/edk.png">

<!-- CSS -->
<link rel="stylesheet" type="text/css" href="../resources/css/map.css">
<link rel="stylesheet" type="text/css" href="../resources/js/map.js">

</head>
<body>

	<!-- 지도를 표시할 div 입니다 -->
	<header>플래너</header>

	<div class="form_wrap">
		<div class="left_form">
		    <h2>좌측박스</h2>
		    <ul>
		        <c:forEach var="marker" items="${markerList}">
			        <div class="left_markerList">
			            <li>
			                <p>ID : ${marker.marker_id}</p>
			                <p>TITLE : ${marker.marker_title}</p>
			                <p>COST : ${marker.marker_cost}</p>
			                <p>TIME : ${marker.marker_time}</p>
			                <p>PAGE : ${marker.marker_page}</p>
			            </li>
		            </div>
		        </c:forEach>
		    </ul>
		</div>

		<div class="map_wrap">
			<div class="center_form" id="map"
				style="width: 800px; height: 600px;"></div>
			<div class="marker_line_field">
				<div class="marker_field">
					마커
					<button class="markerAdd" onclick="toggles('markerAdd')"
						id="markerAdd">추가</button>
					<!-- 	                    <button class="markerEdit" onclick="toggles('markerEdit')" id="markerEdit">수정</button> -->
					<!-- 	                    <button class="markerDel" onclick="toggles('markerDel')" id="markerDel">삭제</button> -->
				</div>
				<div class="line_field">
					선
					<button class="lineAdd" onclick="toggles('lineAdd')" id="lineAdd">추가</button>
					<button class="lineEdit" onclick="toggles('lineEdit')"
						id="lineEdit">수정</button>
					<button class="lineDel" onclick="toggles('lineDel')" id="lineDel">삭제</button>
				</div>
			</div>
		</div>

		<div class="right_form">
			우측박스(오버레이정보 저장)
			<h2>타임테이블</h2>
			<script>
	                // JavaScript를 사용하여 테이블을 동적으로 생성
	                document.write('<table>');
	                document.write('<tr><th style="width: 12%;">시간</th><th style="width: 22%;">1일</th><th style="width: 22%;">2일</th><th style="width: 22%;">3일</th><th style="width: 22%;">4일</th></tr>');
	
	                for (let hour = 0; hour <= 23; hour++) {
	                    document.write('<tr>');
	                    document.write('<td>' + pad(hour) + ':00</td>'); // 시간을 00:00 형식으로 표시
	                    for (let day = 1; day <= 4; day++) {
	                        document.write('<td></td>'); // 각 셀에는 원하는 작업 내용을 추가
	                    }
	                    document.write('</tr>');
	                }
	
	                document.write('</table>');
	
	                // 시간을 00:00 형식으로 변환하는 함수
	                function pad(number) {
	                    return (number < 10 ? '0' : '') + number;
	                }
	            </script>
		</div>
	</div>


	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd2f05e9bb51ec9cd7b4237401d534f1"></script>
	<script>
	    	//커스텀 데이터
		    var CustomOverlayDataArray = [];
	        function CustomOverlayData(id, title, price, time, pageLink) {
	        	this.id = id;
	    		this.title = title;
	    		this.price = price;
	    		this.time = time;
	    		this.pageLink = pageLink;
	    	}
	        //버튼 색상
	        function toggles(action) {
	            // 각 버튼의 색을 원래 색으로 초기화
	            document.getElementById('markerAdd').style.backgroundColor = '';
	            // document.getElementById('markerEdit').style.backgroundColor = '';
	            // document.getElementById('markerDel').style.backgroundColor = '';
	            document.getElementById('lineAdd').style.backgroundColor = '';
	            document.getElementById('lineEdit').style.backgroundColor = '';
	            document.getElementById('lineDel').style.backgroundColor = '';
	
	            // 클릭한 버튼의 색을 변경
	            if (action === 'markerAdd') {
	                document.getElementById('markerAdd').style.backgroundColor = 'rgb(120, 120, 255)';
	                setMarkerAddButtonStatus(true);
	                // setMarkerEditButtonStatus(false);
	                // setMarkerDelButtonStatus(false);
	                setLineAddButtonStatus(false);
	                setLineEditButtonStatus(false);
	                setLineDelButtonStatus(false);
	            // } else if (action === 'markerEdit') {
	            //    document.getElementById('markerEdit').style.backgroundColor = 'rgb(120, 120, 255)';
	            //    setMarkerEditButtonStatus(true);
	            //    setMarkerAddButtonStatus(false);
	            //    setMarkerDelButtonStatus(false);
	            //    setLineAddButtonStatus(false);
	            //    setLineEditButtonStatus(false);
	            //    setLineDelButtonStatus(false);
	            // } else if (action === 'markerDel') {
	            //    document.getElementById('markerDel').style.backgroundColor = 'rgb(120, 120, 255)';
	            //    setMarkerDelButtonStatus(true);
	            //    setMarkerAddButtonStatus(false);
	            //    setMarkerEditButtonStatus(false);
	            //    setLineAddButtonStatus(false);
	            //    setLineEditButtonStatus(false);
	            //    setLineDelButtonStatus(false);
	            } else if (action === 'lineAdd') {
	                document.getElementById('lineAdd').style.backgroundColor = 'rgb(120, 120, 255)';
	                setLineAddButtonStatus(true);
	                setMarkerAddButtonStatus(false);
	            //    setMarkerEditButtonStatus(false);
	            //    setMarkerDelButtonStatus(false);
	                setLineEditButtonStatus(false);
	                setLineDelButtonStatus(false);
	            } else if (action === 'lineEdit') {
	                document.getElementById('lineEdit').style.backgroundColor = 'rgb(120, 120, 255)';
	                setLineEditButtonStatus(true);
	                setMarkerAddButtonStatus(false);
	            //    setMarkerEditButtonStatus(false);
	            //    setMarkerDelButtonStatus(false);
	                setLineAddButtonStatus(false);
	                setLineDelButtonStatus(false);
	            } else if (action === 'lineDel') {
	                document.getElementById('lineDel').style.backgroundColor = 'rgb(120, 120, 255)';
	                setLineDelButtonStatus(true);
	                setMarkerAddButtonStatus(false);
	            //    setMarkerEditButtonStatus(false);
	            //    setMarkerDelButtonStatus(false);
	                setLineAddButtonStatus(false);
	                setLineEditButtonStatus(false);
	            }
	        }
	
	        var markerAddButtonActive = false;
	        // var markerEditButtonActive = false;
	        // var markerDelButtonActive = false;
	        var lineAddButtonActive = false;
	        var lineEditButtonActive = false;
	        var lineDelButtonActive = false;
	
	        function setMarkerAddButtonStatus(active) { markerAddButtonActive = active; }
	        // function setMarkerEditButtonStatus(active) { markerEditButtonActive = active; }
	        // function setMarkerDelButtonStatus(active) { markerDelButtonActive = active; }
	        function setLineAddButtonStatus(active) { lineAddButtonActive = active; }
	        function setLineEditButtonStatus(active) { lineEditButtonActive = active; }
	        function setLineDelButtonStatus(active) { lineDelButtonActive = active; }
	
	        // 지도
	        var mapContainer = document.getElementById('map');
	        var mapOption = {
	            center: new kakao.maps.LatLng(33.506622, 126.493133),
	            level: 5
	        };
	
	        var map = new kakao.maps.Map(mapContainer, mapOption);
	        var markers = [];
	        var overlay; // 오버레이를 전역으로 선언
	
	        kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
	            // 오버레이가 열려있지 않은 경우에만 마커를 생성
	            if (!overlay && markerAddButtonActive) {
	            	var latlng = mouseEvent.latLng;
	                addMarker(mouseEvent.latLng);
	            }
	        });
			var temp;
	        function addMarker(position) {
	        	
	            var marker = new kakao.maps.Marker({
	                position: position,
	                clickable: true
	            });
				temp = marker;
				
				console.log('Marker Latitude:', position.getLat());
			    console.log('Marker Longitude:', position.getLng());
				
	            marker.latlng = position;
	            marker.setClickable(true);
	            
	            //배열 생성
	            // AJAX를 사용하여 서버에 아이디 생성 요청
	            //성공시 서버에서는 nextval를 가져오기
	            //성공시 아래와 같은것을 하기
	            //커스텀 데이터 어레이에 데이터 추가
	            //id, title, .... CustomOverlayDataArray.length를 나중에 id로 바꿀 것
	            CustomOverlayDataArray.push(new CustomOverlayData( CustomOverlayDataArray.length ,'', '', '', ''));
	          	//마커 추가
	            marker.setMap(map);
	            markers.push(marker);
	            kakao.maps.event.addListener(marker, 'click', function (event) {
	            	//지금은 당장 이렇게 쓰지만, 나중에는 아이디 값을 얻어오기
	            	var num = -1;
	            	for(var i=0; i<markers.length; i++){
	            		if (markers[i] == marker) {
	            			num = i;
	            		}
	            	}
	            	//alert("선택된 번호 : "+num);
	            	var inputId=CustomOverlayDataArray[num].id;
	            	var inputTitle=CustomOverlayDataArray[num].title;
	            	var inputPrice=CustomOverlayDataArray[num].price;
	            	var inputTime=CustomOverlayDataArray[num].time;
	            	var inputPageLink=CustomOverlayDataArray[num].pageLink;
                
	                var overlayContent = getOverlayContent(inputId, inputTitle, inputPrice, inputTime, inputPageLink);
	
	                // 기존에 생성된 오버레이가 있으면 닫습니다.
	                if (overlay) { overlay.setMap(null); }
	
	                overlay = new kakao.maps.CustomOverlay({
	                    content: overlayContent,
	                    map: map,
	                    position: marker.getPosition()
	                });
	                overlay.setMap(map);
	            });
	            
	            //실패시에는 위는 안함
	        }
	        
	        
	        function getOverlayContent(inputId, inputTitle, inputPrice, inputTime, inputPageLink){
	        	var str = 
	        		'<div class="wrap">' +
                '    <div class="info">' +
                '        <div class="title">' +
                '            <input type="text" class="form_title" placeholder="장소명" value="'+inputTitle+'">' +
                '            <div class="close" onclick="closeOverlay(event)" title="닫기"></div>' +
                '        </div>' +
                '        <div class="body">' +
                '            <div class="img" width="70" height="70">' +
                '                 <button class="overlayAdd" id="overlayAdd" onclick="addOverlayData(event, '+inputId+')">입력</button><br>' +
                '                 <button class="overlayDel" id="overlayDel">삭제</button>' +
                '            </div>' +
                '            <div class="desc">' +
                '                <p><input type="text" class="form_cost" placeholder="가격직접입력" value="'+inputPrice+'"/></p>' +
                '                <p><input type="text" class="form_time" placeholder="시간직접입력" value="'+inputTime+'"/></p>' +
                '                <p><input type="text" class="form_page" placeholder="페이지링크입력" value="'+inputPageLink+'"/></p>' +
                '            </div>' +
                '        </div>' +
                '    </div>' +
                '</div>';
	        	return str;
	        }
	        
	        function addOverlayData(event, inputId) {
	            var title = overlayContent.querySelector('.form_title').value;
	            var cost = overlayContent.querySelector('.form_cost').value;
	            var time = overlayContent.querySelector('.form_time').value;
	            var page = overlayContent.querySelector('.form_page').value;
				console.log("num : "+inputId);
	            
	            //ajax update
	            //성공시 내 데이터도 수정
	            
	            
	            // AJAX 또는 Fetch API를 사용하여 서버에 데이터를 전송
	            // URL 및 메서드는 서버 측 구현에 따라 조절
	            
	        }
	            
	        function closeOverlay(event) {
	            // 오버레이를 닫습니다.
	            if (overlay) {
	                overlay.setMap(null);
	                overlay = null; // 오버레이를 닫을 때 변수를 초기화
	            }
	
	            // 이벤트 전파를 막습니다.
	            event.stopPropagation();
	        }
	
	        
	     // ------------------------------ 라인 이벤트 ------------------------------ ------------------------------------------------------------
	
	        var drawingFlag = false; // 선이 그려지고 있는 상태를 가지고 있을 변수입니다
	        var moveLine; // 선이 그려지고 있을때 마우스 움직임에 따라 그려질 선 객체 입니다
	        var clickLine // 마우스로 클릭한 좌표로 그려질 선 객체입니다
	        var distanceOverlay; // 선의 거리정보를 표시할 커스텀오버레이 입니다
	        var dots = {}; // 선이 그려지고 있을때 클릭할 때마다 클릭 지점과 거리를 표시하는 커스텀 오버레이 배열입니다.
	
	        // 지도에 클릭 이벤트를 등록합니다
	        // 지도를 클릭하면 선 그리기가 시작됩니다 그려진 선이 있으면 지우고 다시 그립니다
	        kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
	
	            if (!overlay && lineAddButtonActive) {
	                // 마우스로 클릭한 위치입니다 
	                var clickPosition = mouseEvent.latLng;
	
	                // 지도 클릭이벤트가 발생했는데 선을 그리고있는 상태가 아니면
	                if (!drawingFlag) {
	
	                    // 상태를 true로, 선이 그리고있는 상태로 변경합니다
	                    drawingFlag = true;
	
	                    // 지도 위에 선이 표시되고 있다면 지도에서 제거합니다
	                    deleteClickLine();
	
	                    // 지도 위에 커스텀오버레이가 표시되고 있다면 지도에서 제거합니다
	                    deleteDistnce();
	
	                    // 지도 위에 선을 그리기 위해 클릭한 지점과 해당 지점의 거리정보가 표시되고 있다면 지도에서 제거합니다
	                    deleteCircleDot();
	
	                    // 클릭한 위치를 기준으로 선을 생성하고 지도위에 표시합니다
	                    clickLine = new kakao.maps.Polyline({
	                        map: map, // 선을 표시할 지도입니다 
	                        path: [clickPosition], // 선을 구성하는 좌표 배열입니다 클릭한 위치를 넣어줍니다
	                        strokeWeight: 3, // 선의 두께입니다 
	                        strokeColor: '#db4040', // 선의 색깔입니다
	                        strokeOpacity: 1, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
	                        strokeStyle: 'solid' // 선의 스타일입니다
	                    });
	
	                    // 선이 그려지고 있을 때 마우스 움직임에 따라 선이 그려질 위치를 표시할 선을 생성합니다
	                    moveLine = new kakao.maps.Polyline({
	                        strokeWeight: 3, // 선의 두께입니다 
	                        strokeColor: '#db4040', // 선의 색깔입니다
	                        strokeOpacity: 0.5, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
	                        strokeStyle: 'solid' // 선의 스타일입니다    
	                    });
	
	                    // 클릭한 지점에 대한 정보를 지도에 표시합니다
	                    displayCircleDot(clickPosition, 0);
	
	
	                } else { // 선이 그려지고 있는 상태이면
	
	                    // 그려지고 있는 선의 좌표 배열을 얻어옵니다
	                    var path = clickLine.getPath();
	
	                    // 좌표 배열에 클릭한 위치를 추가합니다
	                    path.push(clickPosition);
	
	                    // 다시 선에 좌표 배열을 설정하여 클릭 위치까지 선을 그리도록 설정합니다
	                    clickLine.setPath(path);
	
	                    var distance = Math.round(clickLine.getLength());
	                    displayCircleDot(clickPosition, distance);
	                }
	            }
	        });
	
	        // 지도에 마우스무브 이벤트를 등록합니다
	        // 선을 그리고있는 상태에서 마우스무브 이벤트가 발생하면 그려질 선의 위치를 동적으로 보여주도록 합니다
	        kakao.maps.event.addListener(map, 'mousemove', function (mouseEvent) {
	
	            if (!overlay && lineAddButtonActive) {
	                // 지도 마우스무브 이벤트가 발생했는데 선을 그리고있는 상태이면
	                if (drawingFlag) {
	
	                    // 마우스 커서의 현재 위치를 얻어옵니다 
	                    var mousePosition = mouseEvent.latLng;
	
	                    // 마우스 클릭으로 그려진 선의 좌표 배열을 얻어옵니다
	                    var path = clickLine.getPath();
	
	                    // 마우스 클릭으로 그려진 마지막 좌표와 마우스 커서 위치의 좌표로 선을 표시합니다
	                    var movepath = [path[path.length - 1], mousePosition];
	                    moveLine.setPath(movepath);
	                    moveLine.setMap(map);
	
	                    var distance = Math.round(clickLine.getLength() + moveLine.getLength()), // 선의 총 거리를 계산합니다
	                        content = '<div class="dotOverlay distanceInfo">총거리 <span class="number">' + distance + '</span>m</div>'; // 커스텀오버레이에 추가될 내용입니다
	
	                    // 거리정보를 지도에 표시합니다
	                    showDistance(content, mousePosition);
	                }
	            }
	        });
	
	        // 지도에 마우스 오른쪽 클릭 이벤트를 등록합니다
	        // 선을 그리고있는 상태에서 마우스 오른쪽 클릭 이벤트가 발생하면 선 그리기를 종료합니다
	        kakao.maps.event.addListener(map, 'rightclick', function (mouseEvent) {
	
	            if (!overlay && lineAddButtonActive) {
	                // 지도 오른쪽 클릭 이벤트가 발생했는데 선을 그리고있는 상태이면
	                if (drawingFlag) {
	
	                    // 마우스무브로 그려진 선은 지도에서 제거합니다
	                    moveLine.setMap(null);
	                    moveLine = null;
	
	                    // 마우스 클릭으로 그린 선의 좌표 배열을 얻어옵니다
	                    var path = clickLine.getPath();
	
	                    // 선을 구성하는 좌표의 개수가 2개 이상이면
	                    if (path.length > 1) {
	
	                        // 마지막 클릭 지점에 대한 거리 정보 커스텀 오버레이를 지웁니다
	                        if (dots[dots.length - 1].distance) {
	                            dots[dots.length - 1].distance.setMap(null);
	                            dots[dots.length - 1].distance = null;
	                        }
	
	                        var distance = Math.round(clickLine.getLength()), // 선의 총 거리를 계산합니다
	                            content = getTimeHTML(distance); // 커스텀오버레이에 추가될 내용입니다
	
	                        // 그려진 선의 거리정보를 지도에 표시합니다
	                        showDistance(content, path[path.length - 1]);
	
	                    } else {
	
	                        // 선을 구성하는 좌표의 개수가 1개 이하이면 
	                        // 지도에 표시되고 있는 선과 정보들을 지도에서 제거합니다.
	                        deleteClickLine();
	                        deleteCircleDot();
	                        deleteDistnce();
	
	                    }
	
	                    // 상태를 false로, 그리지 않고 있는 상태로 변경합니다
	                    drawingFlag = false;
	                }
	            }
	        });
	
	        // 클릭으로 그려진 선을 지도에서 제거하는 함수입니다
	        function deleteClickLine() {
	            if (clickLine) {
	                clickLine.setMap(null);
	                clickLine = null;
	            }
	        }
	
	        // 마우스 드래그로 그려지고 있는 선의 총거리 정보를 표시하거
	        // 마우스 오른쪽 클릭으로 선 그리가 종료됐을 때 선의 정보를 표시하는 커스텀 오버레이를 생성하고 지도에 표시하는 함수입니다
	        function showDistance(content, position) {
	
	            if (distanceOverlay) { // 커스텀오버레이가 생성된 상태이면
	
	                // 커스텀 오버레이의 위치와 표시할 내용을 설정합니다
	                distanceOverlay.setPosition(position);
	                distanceOverlay.setContent(content);
	
	            } else { // 커스텀 오버레이가 생성되지 않은 상태이면
	
	                // 커스텀 오버레이를 생성하고 지도에 표시합니다
	                distanceOverlay = new kakao.maps.CustomOverlay({
	                    map: map, // 커스텀오버레이를 표시할 지도입니다
	                    content: content,  // 커스텀오버레이에 표시할 내용입니다
	                    position: position, // 커스텀오버레이를 표시할 위치입니다.
	                    xAnchor: 0,
	                    yAnchor: 0,
	                    zIndex: 3
	                });
	            }
	        }
	
	        // 그려지고 있는 선의 총거리 정보와 
	        // 선 그리가 종료됐을 때 선의 정보를 표시하는 커스텀 오버레이를 삭제하는 함수입니다
	        function deleteDistnce() {
	            if (distanceOverlay) {
	                distanceOverlay.setMap(null);
	                distanceOverlay = null;
	            }
	        }
	
	        // 선이 그려지고 있는 상태일 때 지도를 클릭하면 호출하여 
	        // 클릭 지점에 대한 정보 (동그라미와 클릭 지점까지의 총거리)를 표출하는 함수입니다
	        function displayCircleDot(position, distance) {
	
	            // 클릭 지점을 표시할 빨간 동그라미 커스텀오버레이를 생성합니다
	            var circleOverlay = new kakao.maps.CustomOverlay({
	                content: '<span class="dot"></span>',
	                position: position,
	                zIndex: 1
	            });
	
	            // 지도에 표시합니다
	            circleOverlay.setMap(map);
	
	            if (distance > 0) {
	                // 클릭한 지점까지의 그려진 선의 총 거리를 표시할 커스텀 오버레이를 생성합니다
	                var distanceOverlay = new kakao.maps.CustomOverlay({
	                    content: '<div class="dotOverlay">거리 <span class="number">' + distance + '</span>m</div>',
	                    position: position,
	                    yAnchor: 1,
	                    zIndex: 2
	                });
	
	                // 지도에 표시합니다
	                distanceOverlay.setMap(map);
	            }
	
	            // 배열에 추가합니다
	            dots.push({ circle: circleOverlay, distance: distanceOverlay });
	        }
	
	        // 클릭 지점에 대한 정보 (동그라미와 클릭 지점까지의 총거리)를 지도에서 모두 제거하는 함수입니다
	        function deleteCircleDot() {
	            var i;
	
	            for (i = 0; i < dots.length; i++) {
	                if (dots[i].circle) {
	                    dots[i].circle.setMap(null);
	                }
	
	                if (dots[i].distance) {
	                    dots[i].distance.setMap(null);
	                }
	            }
	
	            dots = [];
	        }
	
	        // 마우스 우클릭 하여 선 그리기가 종료됐을 때 호출하여 
	        // 그려진 선의 총거리 정보와 거리에 대한 도보, 자전거 시간을 계산하여
	        // HTML Content를 만들어 리턴하는 함수입니다
	        function getTimeHTML(distance) {
	
	            // 도보의 시속은 평균 4km/h 이고 도보의 분속은 67m/min입니다
	            var walkkTime = distance / 67 | 0;
	            var walkHour = '', walkMin = '';
	
	            // 계산한 도보 시간이 60분 보다 크면 시간으로 표시합니다
	            if (walkkTime > 60) {
	                walkHour = '<span class="number">' + Math.floor(walkkTime / 60) + '</span>시간 '
	            }
	            walkMin = '<span class="number">' + walkkTime % 60 + '</span>분'
	
	            // 자전거의 평균 시속은 30km/h 이고 이것을 기준으로 자전거의 분속은 500m/min입니다
	            var bycicleTime = distance / 500 | 0;
	            var bycicleHour = '', bycicleMin = '';
	
	            // 계산한 자전거 시간이 60분 보다 크면 시간으로 표출합니다
	            if (bycicleTime > 60) {
	                bycicleHour = '<span class="number">' + Math.floor(bycicleTime / 60) + '</span>시간 '
	            }
	            bycicleMin = '<span class="number">' + bycicleTime % 60 + '</span>분'
	
	            // 거리와 도보 시간, 자전거 시간을 가지고 HTML Content를 만들어 리턴합니다
	            var content = '<ul class="dotOverlay distanceInfo">';
	            content += '    <li>';
	            content += '        <span class="label">총거리</span><span class="number">' + distance + '</span>m';
	            content += '    </li>';
	            content += '    <li>';
	            content += '        <span class="label">도보</span>' + walkHour + walkMin;
	            content += '    </li>';
	            content += '    <li>';
	            content += '        <span class="label">차량</span>' + bycicleHour + bycicleMin;
	            content += '    </li>';
	            content += '</ul>'
	
	            return content;
	        }
	
	
	    </script>
</body>

</html>