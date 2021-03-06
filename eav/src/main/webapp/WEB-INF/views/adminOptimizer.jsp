<%--
  Created by IntelliJ IDEA.
  User: Hroniko
  Date: 21.04.2017
  Time: 12:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf8"
         pageEncoding="utf8" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- Страничка оптимизатора для администратора встречи -->
<html>
<head>
    <title>Оптимизатор встречи ${meeting.title}</title>
    <%@include file='header.jsp'%>

    <meta charset="UTF-8">

    <link rel="stylesheet" type="text/css" href="/resources/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/bootstrap-select.min.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/tipped.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/vis.min.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/tlmain.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/jquery.mCustomScrollbar.min.css">

    <script type="text/javascript" src="/resources/js/jquery-1.9.1.min.js"> </script>
    <script type="text/javascript" src="/resources/js/moment-with-locales.min.js"> </script>
    <script type="text/javascript" src="/resources/js/tipped.js"> </script>
    <script type="text/javascript" src="/resources/js/vis.js"> </script>
    <script type="text/javascript" src="/resources/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/resources/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="/resources/js/bootstrap-select.min.js"> </script>
    <script type="text/javascript" src="/resources/js/jquery.mCustomScrollbar.concat.min.js"> </script>

    <!-- 2017-05-12 Для работы чата (остальное в файле chat.js) -->
    <script type="text/javascript" src="/resources/js/chat.js"> </script>
    <script type="text/javascript">
        // Для работы чата (остальное в файле chat.js)
        var v_message_id = 0;
        var v_meeting_id = '${meeting.id}';
    </script>



    <style type="text/css">
        p{
            margin: 0px;
        }
        .hideinput{
            margin-bottom: 0.5rem;
        }
        .input-group-addon-my{
            min-width: 9rem;
        }
    </style>


    <script>
        var m_id = ${meeting.id};
        var str = "";
        <c:forEach items="${ids}" var="users_id">
        str = str + ${users_id} + ", ";
        </c:forEach>
    </script>


    <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/slots.js"></script>


    <script type="text/javascript">
        // 2017-05-08 Для вывода первого таймера (обратный отсчет до окончания времени редактирования)
        function getfrominputs_001() {
            string_001 = "${timer_001}"; // string_001 = "05/11/2017 10:44"; //
            get_timer_001(string_001);
            setInterval(function () {
                get_timer_001(string_001);
            }, 1000);
        }
        $(document).ready(function () {
            getfrominputs_001();
        });
    </script>
    <script type="text/javascript">
        // 2017-05-08 Для вывода второго таймера  (обратный отсчет до начала встречи)
        function getfrominputs_002() {
            string_002 = "${timer_002}"; // string_002 = "05/12/2017 23:44"; //
            get_timer_002(string_002);
            setInterval(function () {
                get_timer_002(string_002);
            }, 1000);
        }
        $(document).ready(function () {
            getfrominputs_002();
        });
    </script>

</head>
<body>
<div class="container top-buffer-20">

    <!-- Информация о встрече -->
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-3">
            <!-- Место первого таймера (обратный отсчет до окончания времени редактирования) -->
            <%@include file='countdown_001.jsp'%>
            <!-- Окончание первого таймера -->
            <div class="card">
                <h3 class="card-title text-center" id="pTitle">${meeting.title}</h3>
                <div class="profile-userbuttons">
                    <c:if test="${meeting.status eq 'active'}">
                        <button type="button" class="btn btn-info btn-sm" id="settingsButton">
                            <span class='glyphicon glyphicon-cog' aria-hidden='true'> Настройки</span>
                        </button>
                    </c:if>
                    <c:if test="${meeting.status eq 'active'}">
                        <a href="/closeMeeting${meeting.id}">
                            <button type="button" class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"> Закрыть</span>
                            </button>
                        </a>
                    </c:if>
                    <c:if test="${meeting.status eq 'closed'}">
                        <a href="/deleteMeeting${meeting.id}">
                            <button type="button" class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"> Удалить</span>
                            </button>
                        </a>
                    </c:if>
                </div>
                <ul class="list-group list-group-my list-group-flush" id="meetingInfo">
                    <div class="list-group-item">
                        <p id="pOrganizer">Организатор: <a href='/viewProfile${meeting.organizer.id}'>Вы</a></p>
                    </div>
                    <div class="list-group-item">
                        <p id="pDate_start">Начало: ${meeting.date_start}</p>
                    </div>
                    <div class="list-group-item">
                        <p id="pDate_end">Окончание: ${meeting.date_end}</p>
                    </div>
                    <div class="list-group-item">
                        <p id="pDescription">Описание: ${meeting.info}</p>
                    </div>
                    <div class="list-group-item">
                        <p id="pTag" >Теги: ${meeting.tag}</p>
                    </div>
                </ul>
                <form id="meetingUpdateForm" name="update" action="/updateMeeting${meeting.id}" method="post" style="margin-bottom: 0px; padding-left: 1rem; border-top: 1px solid rgb(200, 200, 200);padding-right: 1rem;margin-top: 0rem;">
                    <div class="form-group hideinput">
                        <label class="control-label" for="title">Название</label>
                        <input id="title" name="title" type="text" class="form-control">
                    </div>
                    <div class="form-group hideinput">
                        <label class="control-label" for="date_start">Начало</label>
                        <input id="date_start" name="date_start" type="text" class="form-control">
                    </div>
                    <div class="form-group hideinput">
                        <label class="control-label" for="date_end">Окончание</label>
                        <input id="date_end" name="date_end" type="text" class="form-control">
                    </div>
                    <div class="form-group hideinput">
                        <label class="control-label" for="description">Описание</label>
                        <input id="description" name="info" type="text" class="form-control">
                    </div>
                    <div class="form-group hideinput">
                        <label class="control-label" for="tag">Теги</label>
                        <input id="tag" name="tag" type="text" class="form-control">
                    </div>
                </form>
                <!-- СВЕРХУ НОВОЕ -->
                <c:if test="${meeting.status eq 'active'}">
                    <form id="meetingForm" name="addUser" action="/inviteUserAtMeeting${meeting.id}" method="post" style="margin-bottom: 0px;">
                        <input type="text" class="hidden" name="userIDs" id="userIDs" value = "userIDs"></input>
                        <div class="form-inline" id="inviteAtMeetingForm">
                            <select class="selectpicker form-control" id="inviteAtMeetingSelectPicker"
                                    multiple data-live-search="true"
                                    title="<span class='glyphicon glyphicon-th-list' aria-hidden='true'></span> Пригласить участников"
                                    data-selected-text-format="count>0" data-count-selected-text="Выбрано участников: {0}"
                                    data-none-results-text="Никого не найдено" data-actions-box="true"
                                    data-select-all-text="Выбрать всех" data-deselect-all-text="Убрать всех"
                                    data-size="8" data-dropup-auto="false"
                                    data-style="">
                                <c:forEach items="${meeting.organizer.friends}" var="friend">
                                    <option value="${friend.id}">${friend.name} ${friend.surname}</option>
                                </c:forEach>
                            </select>
                            <span class="form-group-btn">
                            <button id="inviteButton" type="submit" class="btn btn-primary btn-group-justified">
                              <span class="glyphicon glyphicon glyphicon-user" aria-hidden="true"></span> Пригласить
                            </button>
                        </span>
                        </div>
                    </form>
                </c:if>
            </div>
        </div>


        <!--  <div class="container">
              <div class="row">
                  <div class="col-md-5">
                      <div class="panel panel-primary">
                          <div class="panel-heading" id="accordion">
                              <span class="glyphicon glyphicon-comment"></span> Список свободных слотов для встречи за текущую неделю
                              <div class="btn-group pull-right">
                                  <a type="button" class="btn btn-default btn-xs" data-toggle="collapse" data-parent="#accordion"
                                     href="#collapseOne">
                                      <span class="glyphicon glyphicon-chevron-down"></span>
                                  </a>
                              </div>
                          </div>
                          <div class="panel-collapse in" id="collapseOne">
                              <div class="panel-body">
                                  <ul class="chat">
                                      <p id="result_array"></p>
                                  </ul>
                              </div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>     -->




        <!-- ЧАТ -->
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-4 col-lg-offset-5">
            <!-- Место второго таймера (обратный отсчет до начала встречи) -->
            <%@include file='countdown_002.jsp'%>
            <!-- Окончание второго таймера -->

            <div class="card">
                <div class="card-title">
                    <h3 class="text-center" id="cardsholder">Чат</h3>
                </div>
                <ul class="list-group list-group-my list-group-flush text-left chat mCustomScrollbar"
                    data-mcs-theme="minimal-dark" id="cardsholderItems" style="background-color: rgb(238, 238, 238); position: relative;min-height: 30rem;max-height: 30rem;">

                    <div id = "insert_place_messages"></div> <!-- 2017-05-12 Место вставки сообщений, см. chat.js -->

                </ul>

                <form id="messageSend" name="creation" method="post" style="margin-bottom: 0px;"> <!-- 2017-05-12 Кнопка отправки сообщений, см. chat.js -->
                    <div class="input-group">
                        <textarea class="form-control custom-control" rows="2" style="resize:none"
                                  placeholder="Введите сообщение" maxlength="70" id="messageInput">
                        </textarea>

                        <span class="input-group-addon btn btn-primary" id="messageSendButton" title="Отправить">
							<span class="glyphicon glyphicon-send"></span>
						</span>
                    </div>
                </form>


                <div class="input-group">
					<span class="input-group-addon ">
						<div class="text-right" id="textarea_feedback">
						Осталось
						</div>
					</span>
                </div>
            </div>
        </div>
    </div>
    <!-- Timeline и кнопки -->
    <div class="row">
        <div class="col-md-12">

            <p style="background:#3498db; color:#ffffff;" id="elem2" class="text-center"> Оптимизация времени проведения встречи, текущий период: с [${meeting.date_start}] до [${meeting.date_end}]</p>
            <br>

            <div id ="optimizerButtons">
                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                    <a href="/meeting${meeting_id}">
                        <button type="button" class="btn btn-info btn-sm"><span class="glyphicon glyphicon-zoom-in" aria-hidden="true" > Встреча</span></button>
                    </a>
                    <a href="/adminOptimizerExecutor/${meeting_id}">
                        <button type="button" class="btn btn-warning btn-sm"><span class="glyphicon glyphicon-flash" aria-hidden="true"> Оптимизировать</span></button>
                    </a>
                    <a href="/adminOptimizerReset/${meeting_id}">
                        <button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-remove" aria-hidden="true"> Отменить</span></button>
                    </a>
                    <a href="/adminOptimizerSave/${meeting_id}">
                        <button type="button" class="btn btn-success btn-sm"><span class="glyphicon glyphicon-ok" aria-hidden="true"> Сохранить</span></button>
                    </a>
                    <a href="/userOptimizerProblem">
                        <button type="button" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-list-alt" aria-hidden="true" > Список проблем</span></button>
                    </a>
                </div>
            </div>
            <br>

            <div id ="timelineContainer">
                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-default timeline-menu-button" id="showTodayButton">Cегодня
                        </button>
                    </div>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-default timeline-menu-button" id="showWeekButton">Неделя
                        </button>
                    </div>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-default timeline-menu-button" id="showMonthButton">Месяц
                        </button>
                    </div>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-default timeline-menu-button" id="showYearButton">Год</button>
                    </div>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-default timeline-menu-button" id="showMeetingButton">Встреча</button>
                    </div>
                </div>
                <div id="visualization"></div>
                <p style="background:#3498db; color:#ffffff;" id="elem" class="text-center"> ${info_message}</p>
            </div>
        </div>
    </div>
    <!-- Форма для создания новой задачи -->
    <div id="taskmodal" class="modal fade">
        <div class="modal-dialog">
            <form id="eventForm" name="creation" action="/userAddEvent" method="post">
                <div class="modal-content">
                    <!-- Заголовок модального окна -->
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title text-center">Создание новой задачи</h4>
                    </div>
                    <!-- Основное содержимое модального окна -->
                    <div class="modal-body">
                        <div class='row '>
                            <div class='col-md-6'>
                                <div class="input-group">
                                    <span class="input-group-addon">Название</span>
                                    <input type="text" class="form-control" id="taskName"
                                           placeholder="Введите название задачи">
                                </div>
                            </div>
                            <div class='col-md-6'>
                                <div class="input-group">
                                    <div type="text" class="hidden" name="eventId" id="eventId" value="mras"></div>
                                    <span class="input-group-addon" style="border-top-left-radius:4px;border-bottom-left-radius:4px;">Приоритет</span>
                                    <select id="taskPriority" class="selectpicker form-control" title="Выберите приоритет">
                                        <option style="background: #d9534f; color: #fff;" value="Style1">Высокий</option>
                                        <option style="background: #f0ad4e; color: #fff;" value="Style2">Средний</option>
                                        <option style="background: #5bc0de; color: #fff;" value="Style3" selected>Низкий
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <!-- DateTime Pickers -->
                        <div class='row top-buffer-2'>
                            <div class='col-md-6'>
                                <div class='input-group date' id='datetimepicker1'>
                                    <span class="input-group-addon">Начало</span>
                                    <input type='text' class="form-control" id="taskStartTime" style="font-size: 13px;"/>
                                    <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                            </span>
                                </div>
                            </div>
                            <div class='col-md-6'>
                                <div class='input-group date' id='datetimepicker2'>
                                    <span class="input-group-addon">Конец</span>
                                    <input type='text' class="form-control" id="taskEndTime" style="font-size: 13px;"/>
                                    <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                            </span>
                                </div>
                            </div>
                        </div>
                        <div class="row top-buffer-2">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group-addon textarea-addon">Дополнительная информация</div>
                                    <textarea class="form-control noresize textarea-for-modal" rows="5"
                                              id="taskAddInfo"></textarea>
                                </div>
                            </div>
                        </div>
                        <ul class="list-group list-group-my">
                            <li class="list-group-item">
                                Сохранить шаблон
                                <div class="material-switch pull-right">
                                    <input id="SaveTemplateCheckBox" type="checkbox"/>
                                    <label for="SaveTemplateCheckBox" class="label-primary"></label>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <!-- Футер модального окна -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
                        <button type="button" class="btn btn-primary" id="modalAddButton">Добавить</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div id="log"></div>
</div>

<style type="text/css">
    #elem {display:none;}
    #elem2 {display:block;}
</style>

<script type="text/javascript">
    // Нажатие Enter в поле ввода чата
    $('#messageInput').keyup(function(e){
        if(e.keyCode == 13) {
            sendMessageChat();
        }
    });
    $('#messageSendButton').click(function(e){
        sendMessageChat();
    });
    $("#cardsholderItems").mCustomScrollbar({
        scrollInertia: 275
    });
</script>

<script type="text/javascript">
    // Для вывода полоски сообщения снизу под таймлайном
    $("#elem").show('slow');
    setTimeout(function() { $("#elem").hide('slow'); }, 4000);
</script>



<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/tags.js"></script>
<script type="text/javascript">
    // Переключение между просмотром и редактированием
    $(".hideinput").hide();
    $("#settingsButton").click(function(){
        var title = $("#pTitle").text();
        if ($(this).html() == '<span class="glyphicon glyphicon-ok" aria-hidden="true"> Принять</span>'){
            $(this).html('<span class="glyphicon glyphicon-cog" aria-hidden="true"> Настройки</span>');
            //$(this).prop("type", "submit");
            callAJAX();
            $("#meetingInfo").toggle();
            $(".hideinput").toggle();
            return;
        }
        else {
            $(this).html('<span class="glyphicon glyphicon-ok" aria-hidden="true"> Принять</span>');
            $("#title").val(title);
            $("#date_start").val($("#pDate_start").text().substring(8, $("#pDate_start").text().length));
            $("#date_end").val($("#pDate_end").text().substring(11, $("#pDate_end").text().length));
            $("#description").val($("#pDescription").text().substring(10, $("#pDescription").text().length));
            $("#tag").val($("#pTag").text().substring(6, $("#pTag").text().length));
            //$(this).prop("type", "button");
            $("#pTitle").text("Настройки");
        }
        $("#meetingInfo").toggle();
        $(".hideinput").toggle();
    });
    function callAJAX() {
        $.ajax({
            url : '/updateMeetingAJAX${meeting.id}',
            type: 'POST',
            dataType: 'json',
            data : {
                title: $("#title").val(),
                tag: $("#tag").val(),
                date_start: $("#date_start").val(),
                date_end: $("#date_end").val(),
                info: $("#description").val()
            },
            success: function (data) {
                var meeting = JSON.parse(data.text);
                $("#pTitle").text(meeting.title);
                document.title = meeting.title;
                $("#pDate_start").text('Начало: ' + meeting.date_start);
                $("#pDate_end").text('Окончание: ' + meeting.date_end);
                $("#pDescription").text('Описание: ' + meeting.info);
                $("#pTag").text('Теги: ' + meeting.tag);
            }
        });
    }
    $("#cardsholderItems").mCustomScrollbar({
        scrollInertia: 275
    });
    // Нажатие кнопки "Пригласить"
    $("#inviteButton").click(function () {
        if ($('#inviteAtMeetingSelectPicker').val() == null) {
            // Какой нибудь алерт
            return false;
        }
        $("#userIDs").val($('#inviteAtMeetingSelectPicker').val());
        $('#inviteAtMeetingSelectPicker').selectpicker('deselectAll');
    });
    // Лимит числа символов в сообщении
    $(function () {
        var text_max = 70;
        $('#textarea_feedback').html('Осталось символов: ' + text_max);
        $('#messageInput').keydown(function () {
            var text_length = $('#messageInput').val().length;
            var text_remaining = text_max - text_length;
            $('#textarea_feedback').html('Осталось символов: ' + text_remaining);
        });
    });
    // Modal datetimepickers для создания новой задачи
    $(function () {
        $('#datetimepicker1').datetimepicker({
            locale: 'ru'
            //format: "DD/MM/YYYY hh:mm"
        });
        $('#datetimepicker2').datetimepicker({
            locale: 'ru',
            useCurrent: false
        });
        $("#datetimepicker1").on("dp.change", function (e) {
            $('#datetimepicker2').data("DateTimePicker").minDate(e.date);
        });
        $("#datetimepicker2").on("dp.change", function (e) {
            $('#datetimepicker1').data("DateTimePicker").maxDate(e.date);
        });
    });
    // Нажатие кнопки под шаблонами
    document.getElementById('messageSendButton').onclick = function () {
    };
    // Нажатие кнопки "Добавить" в всплывающем окне
    document.getElementById('modalAddButton').onclick = function () {
        $('#taskmodal').modal('hide');
    };
</script>

<script type="text/javascript">
    // TIMELINE FILL, SETUP AND CREATE
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var container = document.getElementById('visualization');
    // Группы элементов (1 группа - 1 пользователь)
    var groups = new vis.DataSet();
    groups.add([
        <c:forEach items="${meeting.users}" var="user">
        {
            id: ${user.id},
            content: "<a href='/user${user.id}'>${user.name} ${user.middleName} ${user.surname}</a>",
        },
        </c:forEach>
        {
            id: 0,
            content: "<b>Расписание встречи</b>"
        }
    ]);
    // Create a DataSet (allows two way data-binding) // 2017-05-07 Подправил, чтобы не выводилось расписание пользователей, а только сама встреча и ее дубликаты
    var items = new vis.DataSet([
        <c:forEach items="${meeting.users}" var="user"> // обходим всех прикрепленных пользователей
        <c:forEach items="${user.eventsUser}" var="event"> // и в каждого пользователя - все события (ищем дубликат, который есть в дуюликатах встречи)
        <c:forEach items="${meeting.duplicates}" var="duplicate"> // обходим дубликаты
        <c:if test="${event.id eq duplicate.id}"> // ищем совпадение, и если оно есть, то это дубликат, его выводим на таймлайн
        {
            id: ${event.id},
            group: ${user.id},
            editable: false,
            content: '${event.name}',
            start: new Date(getDateFromString('${duplicate.date_begin}')),
            end: new Date(getDateFromString('${duplicate.date_end}')),
            className: '${event.priority}'
        },
        </c:if>
        </c:forEach>
        </c:forEach>
        </c:forEach>
        {id: 'A', group: 0, type: 'background', start: new Date(getDateFromString('${meeting.date_start}')), end: new Date(getDateFromString('${meeting.date_end}')), className: 'negative'} // Подсветка времени встречи
    ]);
    // Configuration for the Timeline
    var options = {
        locale: 'RU',
        // ЕСЛИ ЭТО СОЗДАТЕЛЬ ВСТРЕЧИ - ЗНАЧЕНИЕ TRUE, ИНАЧЕ - FALSE
        editable: {
            add: true,         // add new items by double tapping
            updateTime: true,  // drag items horizontally
            updateGroup: false, // drag items from one group to another
            remove: true,       // delete an item by tapping the delete button top right
            overrideItems: false  // allow these options to override item.editable
        },
        selectable: true,
        stack: false,
        multiselect: true,
        dataAttributes: 'all',
        start: new Date(getDateFromString('${meeting.date_start}')).setHours(0,0,0,0),
        // Добавление задачи
        onAdd: function (item, callback) {
            $('#taskName').val("Новая задача");
            $("#modalAddButton").html('Добавить');
            document.getElementById('taskStartTime').value = toLocaleDateTimeString(item.start);
            document.getElementById('taskEndTime').value = toLocaleDateTimeString(item.start);
            $('#taskmodal').modal('show');
            document.getElementById('modalAddButton').onclick = function () {
                item.className = $('#taskPriority').val() == '' ? 'Style3' : $('#taskPriority').val();
                item.start = getDateFromString(document.getElementById('taskStartTime').value);
                item.end = getDateFromString(document.getElementById('taskEndTime').value);
                item.content = document.getElementById('taskName').value;
                item.group = 1000;
                $('#taskmodal').modal('hide');
                callback(item);
                createTooltip();
            };
            callback(null);
        },
        // Удаление задачи
        onRemove: function (item, callback) {
            callback(item);
        },
        // Обновление задачи
        onUpdate: function (item, callback) {
            if (item.group == 1000) {
                $("#modalAddButton").html('Сохранить');
                $('#taskStartTime').val(toLocaleDateTimeString(item.start));
                $('#taskEndTime').val(toLocaleDateTimeString(item.end));
                $('#taskName').val(item.content);
                $('#taskPriority').val(item.className);
                $('#taskPriority').selectpicker('refresh');
                $('#taskmodal').modal('show');
                document.getElementById('modalAddButton').onclick = function () {
                    item.className = $('#taskPriority').val() == '' ? 'Style3' : $('#taskPriority').val();
                    item.start = getDateFromString(document.getElementById('taskStartTime').value);
                    item.end = getDateFromString(document.getElementById('taskEndTime').value);
                    item.content = document.getElementById('taskName').value;
                    item.group = 1000;
                    $('#taskmodal').modal('hide');
                    callback(item);
                    createTooltip();
                };
                callback(null);
            } else
                callback(null);
        }
    };
    // Create a Timeline
    var timeline = new vis.Timeline(container, items, groups, options);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Вывод информации, при наведении на элемент
    function createTooltip() {
        Tipped.create('.vis-item', function (element) {
                var itemId = $(element).attr('data-id');
                var item = items.get(itemId);
                return {
                    title: item.content,
                    content: toLocaleDateTimeString(item.start) + ' - ' + toLocaleDateTimeString(item.end)
                }
            },
            {
                position: 'bottom',
                behavior: 'hide',
                cache: false
            }
        );
    }
    // Преобразовать дату в строку формата DD.MM.YYYY hh:mm
    function toLocaleDateTimeString(dateString) {
        var eventTime = dateString.toLocaleTimeString();
        var eventTimeAfter = eventTime.substring(0, eventTime.length - 3);
        if (eventTimeAfter.length < 5)
            eventTimeAfter = '0' + eventTimeAfter;
        var startDate = dateString.toLocaleDateString() + ' ' + eventTimeAfter;
        return startDate;
    }
    // Получить дату из строки вида DD.MM.YYYY hh:mm
    function getDateFromString(dateString) {
        var reggie = /(\d{2}).(\d{2}).(\d{4}) (\d{2}):(\d{2})/;
        var dateArray = reggie.exec(dateString);
        var dateObject = new Date(
            (+dateArray[3]),
            (+dateArray[2]) - 1, // Careful, month starts at 0!
            (+dateArray[1]),
            (+dateArray[4]),
            (+dateArray[5])
        );
        return dateObject;
    }
    // Просмотр сегодняшнего дня
    document.getElementById('showTodayButton').onclick = function () {
        var currentDate = new Date();
        currentDate.setHours(0, 0, 0, 0);
        var nextDay = new Date(currentDate);
        nextDay.setDate(nextDay.getDate() + 1);
        timeline.setWindow(currentDate, nextDay);
    };
    // Просмотр недели
    document.getElementById('showWeekButton').onclick = function () {
        var currentDate = new Date();
        var monday = new Date();
        currentDate.setHours(0, 0, 0, 0);
        var day = currentDate.getDay() || 7;
        if (day !== 1)
            monday.setHours(-24 * (day - 1));
        var inWeek = new Date(monday);
        inWeek.setDate(monday.getDate() + 7);
        timeline.setWindow(monday, inWeek);
    };
    // Просмотр месяца
    document.getElementById('showMonthButton').onclick = function () {
        var currentDate = new Date();
        currentDate.setHours(0, 0, 0, 0);
        var firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
        var lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);
        timeline.setWindow(firstDay, lastDay);
    };
    // Просмотр года
    document.getElementById('showYearButton').onclick = function () {
        var currentDate = new Date();
        currentDate.setHours(0, 0, 0, 0);
        var firstDay = new Date(currentDate.getFullYear(), 0, 1);
        var lastDay = new Date(currentDate.getFullYear(), 12, 0);
        timeline.setWindow(firstDay, lastDay);
    };
    // Просмотр встречи
    document.getElementById('showMeetingButton').onclick = function () {
        var start = new Date(getDateFromString('${meeting.date_start}'));
        var end = new Date(getDateFromString('${meeting.date_end}'));
        timeline.setWindow(start, end);
    };
    createTooltip();
</script>


</body>
<div style="margin-bottom: 8rem;"/>
<%@include file='footer.jsp'%>
</html>