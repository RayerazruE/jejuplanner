<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">

    <!-- 타이틀 -->
    <title>제주도 여행 계획</title>
    <link rel="shortcut icon" href="edk.png">

    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="map.css">


</head>


<body>

    <!-- 지도를 표시할 div 입니다 -->
    <header>제주여행계획</header>

    <div class="left_form"></div>
    <div id="map" style="width:1200px;height:800px;"></div>
    <div class="right_form"></div>

    <footer>페이지체인지</footer>



    <script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd2f05e9bb51ec9cd7b4237401d534f1"></script>
    <script>
        // ------------------------------ 기본 지도 코드 ----------------------------- ------------------------------------------------------------
        var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
            mapOption = {
                center: new kakao.maps.LatLng(33.506622, 126.493133), // 지도의 중심좌표
                level: 4 // 지도의 확대 레벨
            };

        // 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
        var map = new kakao.maps.Map(mapContainer, mapOption);



        // ------------------------------ 마커 이벤트 ------------------------------ ------------------------------------------------------------

        // 지도를 클릭했을때 클릭한 위치에 마커를 추가하도록 지도에 클릭이벤트를 등록합니다
        kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
            // 클릭한 위치에 마커를 표시합니다 
            addMarker(mouseEvent.latLng);
        });

        // 지도에 표시된 마커 객체를 가지고 있을 배열입니다
        var markers = [];

        // 마커를 생성하고 지도위에 표시하는 함수입니다
        function addMarker(position) {

            // 마커를 생성합니다
            var marker = new kakao.maps.Marker({
                position: position,
                clickable: true // 마커를 클릭했을 때 지도의 클릭 이벤트가 발생하지 않도록 설정합니다
            });

            // 마커에 위도와 경도 정보를 저장합니다
            marker.latlng = position;

            // 아래 코드는 위의 마커를 생성하는 코드에서 clickable: true 와 같이
            // 마커를 클릭했을 때 지도의 클릭 이벤트가 발생하지 않도록 설정합니다
            marker.setClickable(true);


            // 마커가 지도 위에 표시되도록 설정합니다
            marker.setMap(map);

            // 생성된 마커를 배열에 추가합니다
            markers.push(marker);
        }

        // ------------------------------ 위 경도 정보 ------------------------------ ------------------------------------------------------------

        // 마커를 클릭했을 때 마커 위에 표시할 인포윈도우를 생성합니다
        var infowindow = new kakao.maps.InfoWindow({
            removable: true
        });

        // 마커에 클릭 이벤트를 등록합니다
        kakao.maps.event.addListener(marker, 'click', function () {
            // 클릭한 마커의 위치 정보를 가져옵니다
            var latlng = marker.getPosition();

            // 인포윈도우에 표시할 내용을 동적으로 생성합니다
            var iwContent = '<div style="padding:5px;">위도: ' + latlng.getLat() + '<br>경도: ' + latlng.getLng() + '</div>';

            // 인포윈도우에 내용을 설정합니다
            infowindow.setContent(iwContent);

            // 마커 위에 인포윈도우를 표시합니다
            infowindow.open(map, marker);
        });


        // ------------------------------ 오버레이 이벤트 ------------------------------ ------------------------------------------------------------

        var content = '<div class="wrap">' +
            '    <div class="info">' +
            '        <div class="title">' +
            '            카카오 스페이스닷원' +
            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' +
            '        </div>' +
            '        <div class="body">' +
            '            <div class="img">' +
            '                <img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/thumnail.png" width="73" height="70">' +
            '           </div>' +
            '            <div class="desc">' +
            '                <div class="ellipsis">제주특별자치도 제주시 첨단로 242</div>' +
            '                <div class="jibun ellipsis">(우) 63309 (지번) 영평동 2181</div>' +
            '                <div><a href="https://www.kakaocorp.com/main" target="_blank" class="link">홈페이지</a></div>' +
            '            </div>' +
            '        </div>' +
            '    </div>' +
            '</div>';

        // 마커 위에 커스텀오버레이를 표시합니다
        // 마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다
        var overlay = new kakao.maps.CustomOverlay({
            content: content,
            map: map,
            position: marker.getPosition()
        });

        // 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
        kakao.maps.event.addListener(marker, 'click', function () {
            overlay.setMap(map);
        });

        // 커스텀 오버레이를 닫기 위해 호출되는 함수입니다 
        function closeOverlay() {
            overlay.setMap(null);
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
        });

        // 지도에 마우스무브 이벤트를 등록합니다
        // 선을 그리고있는 상태에서 마우스무브 이벤트가 발생하면 그려질 선의 위치를 동적으로 보여주도록 합니다
        kakao.maps.event.addListener(map, 'mousemove', function (mouseEvent) {

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
        });

        // 지도에 마우스 오른쪽 클릭 이벤트를 등록합니다
        // 선을 그리고있는 상태에서 마우스 오른쪽 클릭 이벤트가 발생하면 선 그리기를 종료합니다
        kakao.maps.event.addListener(map, 'rightclick', function (mouseEvent) {

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