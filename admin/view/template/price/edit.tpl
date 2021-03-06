<?php echo $header; ?>
<head>
    <script src="view/javascript/jquery.blockUI.js"></script>
    <script type="text/javascript">
        $(document).ajaxStop($.unblockUI);
        $(function() {
            // format number: convert 1234 -> 1,234
            Number.prototype.format = function(n, x) {
                var re = '(\\d)(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
                return this.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$1,');
            };
            // outerHTML technique
            jQuery.fn.outerHTML = function(s) {
                return s
                        ? this.before(s).remove()
                        : jQuery("<p>").append(this.eq(0).clone()).html();
            };

            var jsonElectricityNew = {};
            var jsonWaterNew = {};
            var jsonGarbageNew = {};

            var idApplyingElectricityStandardPrice;
            var idApplyingWaterStandardPrice;
            var idApplyingGarbageStandardPrice;

            var idNewestElectricity = 0;
            var idNewestWater = 0;
            var idNewestGarbage = 0;

            $.ajax({
                url: 'index.php?route=price/edit/loadApplyingElectricityStandardId&token=<?php echo $token; ?>',
                dataType: 'json',
                type: 'post',
                success: function(json) {
                    idApplyingElectricityStandardPrice = json['id'];
                    if ($('#electricity_modified_date').children('option').filter(':selected').val() == idApplyingElectricityStandardPrice) {
                        $('#applyingElectricityStandardPrice').show();
                        $('input[name="applyElectricityStandard"]').prop('disabled', true);
                    } else {
                        $('#applyingElectricityStandardPrice').hide();
                        $('input[name="applyElectricityStandard"]').prop('disabled', false);
                    }
                },
                error: function(xhr) {
                    console.log(xhr);
                }
            });

            $('#dialog-update-electricity-standard').on('click', '.remove', function() {
                var $this = $(this);
                console.log($this);
                if ($this.parent().is(':first-child')) {
                    alert('Không thể xóa dòng này!');
                } else {
                    // the number of elements inside obj object
                    var $prevRow = $this.parent().prev().children('.to').children();
                    var $nextRow = $this.parent().next().children('.from').children();
                    $nextRow.val(parseInt($prevRow.val()) + 1);
                    $this.parent().remove();
                }
            });

            $('#electricity_modified_date').change(function() {
                var $btnCreateNew = $('input[name="createNewElectricityStandard"]');
                var $fromDate = $('#from-date-electricity');
                var $toDate = $('#to-date-electricity');
                if ($(this).children('option').filter(':selected').val() == idApplyingElectricityStandardPrice) {
                    $('#applyingElectricityStandardPrice').show();
                    $('input[name="applyElectricityStandard"]').prop('disabled', true);
                } else {
                    $('#applyingElectricityStandardPrice').hide();
                    $('input[name="applyElectricityStandard"]').prop('disabled', false);
                }
                $.blockUI({ message: '<h3><span><img src="view/image/price/preloader.gif" height="16" width="16" /></span> Đang tải dữ liệu...</h3>' });
                $.ajax({
                    url: 'index.php?route=price/edit/loadElectricityStandardPrice&token=<?php echo $token; ?>',
                    data: { 'id' : $(this).children('option').filter(':selected').val() },
                    dataType: 'json',
                    type: 'post',
                    success: function(json) {
                        var $show = $('.standard_price_show').children('.electricity_standard_price').find('tbody');
                        var $edit = $('.standard_price_edit').find('.electricity_standard_price').find('tbody');
                        // delete all current lines in the table
                        $show.empty();
                        $edit.empty();
                        // loop all elements in a list of objects
                        for (var index in json['data']) {
                            var price = parseInt(json['data'][index]['Price']);
                            var to = json['data'][index]['To'];
                            if (to == -1) {
                                to = '';
                            }
                            // add new lines represent the standard price corresponding to the inputted date
                            $show.append('<tr class="line">' +
                                    '<td class="from">' + json['data'][index]['From'] + '</td>' +
                                    '<td class="to">' + to + '</td>' +
                                    '<td class="price">' + price.format() + '&nbsp₫</td>' + // format function: convert 1234 -> 1,234
                                    '</tr>');
                            $edit.append('<tr class="line">' +
                                    '<td class="from">' + json['data'][index]['From'] + '</td>' +
                                    '<td class="to">' + to + '</td>' +
                                    '<td class="price">' + price.format() + '&nbsp₫</td>' + // format function: convert 1234 -> 1,234
                                    '</tr>');
                        }
                    }, // for debugging purpose
                    error: function(xhr) {
                        console.log(xhr);
                    }
                });
            });

            $('#dialog-update-electricity-standard').dialog({
                autoOpen: false,
                draggable: false,
                resizable: false,
                position: 'center',
                modal: true,
                show: true,
                minHeight: 'auto', // auto expand height
                minWidth: 'auto',
                dialogClass: 'dlg-no-title',
                buttons: {
                    "Cập nhật": function() {
                        var $this = $(this);
                        // check that all cells are inputted
                        var checkFill = true;
                        $('#dialog-update-electricity-standard input').each(function(i, e) {
                            if ($(e).parent().parent().hasClass('line') && $(e).val() == '') {
                                checkFill = false;
                                return false;
                            }
                        });
                        var $lastRow = $('#dialog-update-electricity-standard').find('.line').last();
                        var to = $lastRow.children('.to').children().val();
                        var price = $lastRow.children('.price').children().val();
                        // In order to submit data, the last row must satisfy 2 conditions:
                        // - To = -1
                        // - There is no empty cell in the table
                        if (to == -1 && checkFill) {
                            jsonElectricityNew.electricity_new = {};
                            $('#dialog-update-electricity-standard').find('.line').each(function(index, element) {
                                jsonElectricityNew.electricity_new[index] = {};
                                jsonElectricityNew.electricity_new[index].from = $(element).children('.from').children().val();
                                jsonElectricityNew.electricity_new[index].to = $(element).children('.to').children().val();
                                jsonElectricityNew.electricity_new[index].price = $(element).children('.price').children().val();
                            });

                            var updateDateTo = '';
                            var frDate = $('#from-date-electricity').val();
                            var updateDateFrom = frDate.substr(6, 4) + '-' + frDate.substr(3, 2) + '-' + frDate.substr(0, 2);
                            if ($('#to-date-electricity').val()) {
                                var toDate = $('#to-date-electricity').val();
                                updateDateTo = toDate.substr(6, 4) + '-' + toDate.substr(3, 2) + '-' + toDate.substr(0, 2);
                            }
                            $.ajax({
                                url: 'index.php?route=price/edit/updateElectricityStandardPrice&token=<?php echo $token; ?>',
                                data: {
                                    'electricity_new_data': jsonElectricityNew,
                                    'update_date_from': updateDateFrom,
                                    'update_date_to': updateDateTo,
                                    'id': idNewestElectricity
                                },
                                dataType: 'json',
                                type: 'post',
                                success: function(json) {
                                    var arr = jsonElectricityNew.electricity_new;
                                    var $show = $('.standard_price_show').children('.electricity_standard_price').find('tbody');
                                    var $edit = $('.standard_price_edit').find('.electricity_standard_price').find('tbody');
                                    $show.empty();
                                    $edit.empty();
                                    for (var index in arr) {
                                        var price = parseInt(arr[index].price);
                                        var to = parseInt(arr[index].to);
                                        if (to == -1) {
                                            to = '';
                                        }
                                        $show.append('<tr class="line">' +
                                                '<td class="from">' + arr[index].from + '</td>' +
                                                '<td class="to">' + to + '</td>' +
                                                '<td class="price">' + price.format() + '&nbsp₫</td>' +
                                                '</tr>');
                                        $edit.append('<tr class="line">' +
                                                '<td class="from">' + arr[index].from + '</td>' +
                                                '<td class="to">' + to + '</td>' +
                                                '<td class="price">' + price.format() + '&nbsp₫</td>' +
                                                '</tr>');
                                    }
                                    $this.dialog('close');
                                }, // for debugging purpose
                                error: function(xhr) {
                                    console.log(xhr);
                                }
                            });
                        } else {
                            alert('Bạn chưa nhập đủ dữ liệu');
                        }
                    },
                    "Hủy bỏ": function() {
                        $( this ).dialog( "close" );
                    }
                }
            });

            $('input[name="createNewElectricityStandard"]').click(function() {
                var $fromDate = $('#from-date-electricity');
                var $toDate = $('#to-date-electricity');
                if ($fromDate.datepicker('getDate') && $fromDate.datepicker('getDate') > frDate && $('') && $fromDate.datepicker('getDate') < $toDate.datepicker('getDate')) {
                    var $tbody = $('#dialog-update-electricity-standard').find('tbody');
                    $tbody.empty();
                    // jQuery BlockUI (http://malsup.com/jquery/block/)
                    $.blockUI({ message: '<h3><span><img src="view/image/price/preloader.gif" height="16" width="16" /></span> Đang lấy dữ liệu...</h3>' });
                    $.ajax({
                        url: 'index.php?route=price/edit/loadNewestElectricityStandardPrice&token=<?php echo $token; ?>',
                        dataType: 'json',
                        type: 'post',
                        success: function(json) {
                            // open dialog after loading data successfully
                            $('#dialog-update-electricity-standard').dialog('open');
                            idNewestElectricity = json['id'];
                            for (var index in json['newest']) {
                                var to = json['newest'][index]['To'];
                                if (index == 0) {
                                    $tbody.append('<tr class="line">' +
                                            '<td class="from"><input type="text" style="width: 74px;" disabled="true" value="' + json['newest'][index]['From'] + '"/></td>' +
                                            '<td class="to"><input type="text" style="width: 74px;" value="' + to + '"/></td>' +
                                            '<td class="price"><input type="text" style="width: 74px;" value="' + json['newest'][index]['Price'] + '"/></td>' +
                                            '<td class="remove"></td>' +
                                            '</tr>');
                                } else {
                                    $tbody.append('<tr class="line">' +
                                            '<td class="from"><input type="text" style="width: 74px;" disabled="true" value="' + json['newest'][index]['From'] + '"/></td>' +
                                            '<td class="to"><input type="text" style="width: 74px;" value="' + to + '"/></td>' +
                                            '<td class="price"><input type="text" style="width: 74px;" value="' + json['newest'][index]['Price'] + '"/></td>' +
                                            '<td class="remove"><img src="view/image/price/delete.png" height="16" width="16" /></td>' +
                                            '</tr>');
                                }
                            }
                            $tbody.append('' +
                                    '<tr class="dummy-line">' +
                                    '<td class="from" style="display: none;"><input style="width: 74px;" disabled="true" /></td>' +
                                    '<td class="to" style="display: none;"><input style="width: 74px;" /></td>' +
                                    '<td class="price" style="display: none;"><input style="width: 74px;" /></td>' +
                                    '<td class="remove" style="display: none;"><img src="view/image/price/delete.png" height="16" width="16" /></td>' +
                                    '</tr>' +
                                    '<tr class="plus">' +
                                    '<td><img src="view/image/price/add.png" height="16" width="16" /></td>' +
                                    '<td></td>' +
                                    '<td></td>' +
                                    '<td></td>' +
                                    '</tr>');
                            // input check
                            $('#dialog-update-electricity-standard').find('tbody').focusout(function(e) { // e: event object
                                var $this = $(e.target).closest('.line'); // e.target points to the focus-lost element
                                var $from = $this.children('.from').children();
                                var $to = $this.children('.to').children();
                                var $price = $this.children('.price').children();
                                var to = $to.val();
                                var from = $from.val();
                                var price = $price.val();
                                var isLastRow = $this.parent().is(':last-child');
                                if (to == -1 && isLastRow) {

                                } else if (to && parseInt(to) <= parseInt(from)) {
                                    alert ('Giá trị cột Đến kW phải lớn hơn cột Từ kW');
                                    $to.focus().select();
                                } else if (to && (!$.isNumeric(to) || parseInt(to) < 0)) {
                                    alert('Giá trị nhập vào không hợp lệ');
                                    $to.focus().select();
                                } else if (price && (!$.isNumeric(price) || parseInt(price) < 0)) {
                                    alert('Giá trị nhập vào không hợp lệ');
                                    $price.focus().select();
                                } else {
                                    // change value of From in the next row. From = (last row's To) + 1
                                    var $next = $this.next();
                                    if ($next) {
                                        $next.children('.from').children().val(parseInt(to) + 1);
                                    }
                                }
                            });
                            $('.plus').on('click', function() {
                                $toCell = $('#dialog-update-electricity-standard').find('.line').last().children('.to').children();
                                to = parseInt($toCell.val());
                                if (to == -1) {
                                    alert('Bạn phải nhập giá trị khác -1 cho cột Đến kW ở dòng cuối cùng trước khi thêm dòng mới')
                                } else {
                                    // select dummy-line
                                    $dummy = $('.dummy-line');
                                    // add a new dummy-line after the default dummy-line, change the default dummy-line into a `line` and make all its children visible
                                    // the new dummy-line become the default dummy-line
                                    $dummy.after($dummy.outerHTML()).removeClass("dummy-line").addClass("line")
                                            .children().show() // show newly added row
                                            .end().children('.from').children().val(to + 1); // From = (last To value) + 1
                                }
                            });
                        }, // for debugging purpose
                        error: function(xhr) {
                            console.log(xhr);
                        }
                    });
                } else {
                    alert('Bạn nhập chưa đúng. Hãy kiểm tra lại dữ liệu nhập!');
                }
            });

            $('input[name="applyElectricityStandard"]').click(function() {
                $('#dialog-apply-electricity-standard').dialog('open');
            });

            $('#dialog-apply-electricity-standard').dialog({
                autoOpen: false,
                draggable: true,
                resizable: false,
                position: 'center',
                modal: true,
                show: true,
                minHeight: 'auto', // auto expand height
                minWidth: 'auto',
                buttons: {
                    "Đồng ý": function() {
                        var done = false;
                        $.ajax({
                            url: 'index.php?route=price/edit/applyElectricityStandardPrice&token=<?php echo $token; ?>',
                            data: { 'id' : $('#electricity_modified_date').children('option').filter(':selected').val() },
                            dataType: 'json',
                            type: 'post',
                            success: function() {
                            },
                            error: function(xhr) {
                                console.log(xhr);
                            }
                        });
                        idApplyingElectricityStandardPrice = $('#electricity_modified_date').children('option').filter(':selected').val();
                        $('#applyingElectricityStandardPrice').show();
                        $('input[name="applyElectricityStandard"]').prop('disabled', true);
                        $(this).dialog("close");
                    },
                    "Hủy bỏ": function() {
                        $(this).dialog("close");
                    }
                }
            });

            $('#from-date-electricity').datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function(selectedDate) {
                    var dateFrom = $('#from-date-electricity').datepicker('getDate');
                    var dateTo = $('#to-date-electricity').datepicker('getDate');
                    if (dateFrom && dateTo && dateFrom > dateTo) {
                        alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc!');
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                    if (dateFrom < frDate) {
                        alert("Không thể chọn ngày bắt đầu trong quá khứ!");
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                }
            });

            $('#to-date-electricity').datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function(selectedDate) {
                    var dateFrom = $('#from-date-electricity').datepicker('getDate');
                    var dateTo = $('#to-date-electricity').datepicker('getDate');
                    if (dateFrom && dateTo && dateFrom > dateTo) {
                        alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc!');
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                }
            });
            //==========================================================================================================
            $.ajax({
                url: 'index.php?route=price/edit/loadApplyingWaterStandardId&token=<?php echo $token; ?>',
                dataType: 'json',
                type: 'post',
                success: function(json) {
                    idApplyingWaterStandardPrice = json['id'];
                    if ($('#water_modified_date').children('option').filter(':selected').val() == idApplyingWaterStandardPrice) {
                        $('#applyingWaterStandardPrice').show();
                        $('input[name="applyWaterStandard"]').prop('disabled', true);
                    } else {
                        $('#applyingWaterStandardPrice').hide();
                        $('input[name="applyWaterStandard"]').prop('disabled', false);
                    }
                },
                error: function(xhr) {
                    console.log(xhr);
                }
            });

            $('#dialog-update-water-standard').on('click', '.remove', function() {
                var $this = $(this);
                console.log($this);
                if ($this.parent().is(':first-child')) {
                    alert('Không thể xóa dòng này!');
                } else {
                    // the number of elements inside obj object
                    var $prevRow = $this.parent().prev().children('.to').children();
                    var $nextRow = $this.parent().next().children('.from').children();
                    $nextRow.val(parseInt($prevRow.val()) + 1);
                    $this.parent().remove();
                }
            });

            $('#water_modified_date').change(function() {
                var $btnCreateNew = $('input[name="createNewWaterStandard"]');
                var $fromDate = $('#from-date-water');
                var $toDate = $('#to-date-water');
                if ($(this).children('option').filter(':selected').val() == idApplyingWaterStandardPrice) {
                    $('#applyingWaterStandardPrice').show();
                    $('input[name="applyWaterStandard"]').prop('disabled', true);
                } else {
                    $('#applyingWaterStandardPrice').hide();
                    $('input[name="applyWaterStandard"]').prop('disabled', false);
                }
                $.blockUI({ message: '<h3><span><img src="view/image/price/preloader.gif" height="16" width="16" /></span> Đang tải dữ liệu...</h3>' });
                $.ajax({
                    url: 'index.php?route=price/edit/loadWaterStandardPrice&token=<?php echo $token; ?>',
                    data: { 'id' : $(this).children('option').filter(':selected').val() },
                    dataType: 'json',
                    type: 'post',
                    success: function(json) {
                        var $show = $('.standard_price_show').children('.water_standard_price').find('tbody');
                        var $edit = $('.standard_price_edit').find('.water_standard_price').find('tbody');
                        // delete all current lines in the table
                        $show.empty();
                        $edit.empty();
                        // loop all elements in a list of objects
                        for (var index in json['data']) {
                            var price = parseInt(json['data'][index]['Price']);
                            var to = json['data'][index]['To'];
                            if (to == -1) {
                                to = '';
                            }
                            // add new lines represent the standard price corresponding to the inputted date
                            $show.append('<tr class="line">' +
                                    '<td class="from">' + json['data'][index]['From'] + '</td>' +
                                    '<td class="to">' + to + '</td>' +
                                    '<td class="price">' + price.format() + '&nbsp₫</td>' + // format function: convert 1234 -> 1,234
                                    '</tr>');
                            $edit.append('<tr class="line">' +
                                    '<td class="from">' + json['data'][index]['From'] + '</td>' +
                                    '<td class="to">' + to + '</td>' +
                                    '<td class="price">' + price.format() + '&nbsp₫</td>' + // format function: convert 1234 -> 1,234
                                    '</tr>');
                        }
                    }, // for debugging purpose
                    error: function(xhr) {
                        console.log(xhr);
                    }
                });
            });

            $('#dialog-update-water-standard').dialog({
                autoOpen: false,
                draggable: false,
                resizable: false,
                position: 'center',
                modal: true,
                show: true,
                minHeight: 'auto', // auto expand height
                minWidth: 'auto',
                dialogClass: 'dlg-no-title',
                buttons: {
                    "Cập nhật": function() {
                        var $this = $(this);
                        // check that all cells are inputted
                        var checkFill = true;
                        $('#dialog-update-water-standard input').each(function(i, e) {
                            if ($(e).parent().parent().hasClass('line') && $(e).val() == '') {
                                checkFill = false;
                                return false;
                            }
                        });
                        var $lastRow = $('#dialog-update-water-standard').find('.line').last();
                        var to = $lastRow.children('.to').children().val();
                        var price = $lastRow.children('.price').children().val();
                        // In order to submit data, the last row must satisfy 2 conditions:
                        // - To = -1
                        // - There is no empty cells in the table
                        if (to == -1 && checkFill) {
                            jsonWaterNew.water_new = {};
                            $('#dialog-update-water-standard').find('.line').each(function(index, element) {
                                jsonWaterNew.water_new[index] = {};
                                jsonWaterNew.water_new[index].from = $(element).children('.from').children().val();
                                jsonWaterNew.water_new[index].to = $(element).children('.to').children().val();
                                jsonWaterNew.water_new[index].price = $(element).children('.price').children().val();
                            });
                            var updateDateTo = '';
                            var frDate = $('#from-date-water').val();
                            var updateDateFrom = frDate.substr(6, 4) + '-' + frDate.substr(3, 2) + '-' + frDate.substr(0, 2);
                            if ($('#to-date-water').val()) {
                                var toDate = $('#to-date-water').val();
                                updateDateTo = toDate.substr(6, 4) + '-' + toDate.substr(3, 2) + '-' + toDate.substr(0, 2);
                            }
                            $.ajax({
                                url: 'index.php?route=price/edit/updateWaterStandardPrice&token=<?php echo $token; ?>',
                                data: {
                                    'water_new_data': jsonWaterNew,
                                    'update_date_from': updateDateFrom,
                                    'update_date_to': updateDateTo,
                                    'id': idNewestWater
                                },
                                dataType: 'json',
                                type: 'post',
                                success: function(json) {
                                    var arr = jsonWaterNew.water_new;
                                    var $show = $('.standard_price_show').children('.water_standard_price').find('tbody');
                                    var $edit = $('.standard_price_edit').find('.water_standard_price').find('tbody');
                                    $show.empty();
                                    $edit.empty();
                                    for (var index in arr) {
                                        var price = parseInt(arr[index].price);
                                        var to = parseInt(arr[index].to);
                                        if (to == -1) {
                                            to = '';
                                        }
                                        $show.append('<tr class="line">' +
                                                '<td class="from">' + arr[index].from + '</td>' +
                                                '<td class="to">' + to + '</td>' +
                                                '<td class="price">' + price.format() + '&nbsp₫</td>' +
                                                '</tr>');
                                        $edit.append('<tr class="line">' +
                                                '<td class="from">' + arr[index].from + '</td>' +
                                                '<td class="to">' + to + '</td>' +
                                                '<td class="price">' + price.format() + '&nbsp₫</td>' +
                                                '</tr>');
                                    }
                                    $this.dialog('close');
                                }, // for debugging purpose
                                error: function(xhr) {
                                    console.log(xhr);
                                }
                            });
                        } else {
                            alert('Bạn chưa nhập đủ dữ liệu');
                        }
                    },
                    "Hủy bỏ": function() {
                        $( this ).dialog( "close" );
                    }
                }
            });

            $('input[name="createNewWaterStandard"]').click(function() {
                if ($('#from-date-water').val()) {
                    var $tbody = $('#dialog-update-water-standard').find('tbody');
                    $tbody.empty();
                    // jQuery BlockUI (http://malsup.com/jquery/block/)
                    $.blockUI({ message: '<h3><span><img src="view/image/price/preloader.gif" height="16" width="16" /></span> Đang lấy dữ liệu...</h3>' });
                    $.ajax({
                        url: 'index.php?route=price/edit/loadNewestWaterStandardPrice&token=<?php echo $token; ?>',
                        dataType: 'json',
                        type: 'post',
                        success: function(json) {
                            // open dialog after loading data successfully
                            $('#dialog-update-water-standard').dialog('open');
                            idNewestWater = json['id'];
                            for (var index in json['newest']) {
                                var to = json['newest'][index]['To'];
                                if (index == 0) {
                                    $tbody.append('<tr class="line">' +
                                            '<td class="from"><input type="text" style="width: 74px;" disabled="true" value="' + json['newest'][index]['From'] + '"/></td>' +
                                            '<td class="to"><input type="text" style="width: 74px;" value="' + to + '"/></td>' +
                                            '<td class="price"><input type="text" style="width: 74px;" value="' + json['newest'][index]['Price'] + '"/></td>' +
                                            '<td class="remove"></td>' +
                                            '</tr>');
                                } else {
                                    $tbody.append('<tr class="line">' +
                                            '<td class="from"><input type="text" style="width: 74px;" disabled="true" value="' + json['newest'][index]['From'] + '"/></td>' +
                                            '<td class="to"><input type="text" style="width: 74px;" value="' + to + '"/></td>' +
                                            '<td class="price"><input type="text" style="width: 74px;" value="' + json['newest'][index]['Price'] + '"/></td>' +
                                            '<td class="remove"><img src="view/image/price/delete.png" height="16" width="16" /></td>' +
                                            '</tr>');
                                }
                            }
                            $tbody.append('' +
                                    '<tr class="dummy-line">' +
                                    '<td class="from" style="display: none;"><input style="width: 74px;" disabled="true" /></td>' +
                                    '<td class="to" style="display: none;"><input style="width: 74px;" /></td>' +
                                    '<td class="price" style="display: none;"><input style="width: 74px;" /></td>' +
                                    '<td class="remove" style="display: none;"><img src="view/image/price/delete.png" height="16" width="16" /></td>' +
                                    '</tr>' +
                                    '<tr class="plus">' +
                                    '<td><img src="view/image/price/add.png" height="16" width="16" /></td>' +
                                    '<td></td>' +
                                    '<td></td>' +
                                    '<td></td>' +
                                    '</tr>');
                            // input check
                            $('#dialog-update-water-standard').find('tbody').focusout(function(e) { // e: event object
                                var $this = $(e.target).closest('.line'); // e.target points to the focus-lost element
                                var $from = $this.children('.from').children();
                                var $to = $this.children('.to').children();
                                var $price = $this.children('.price').children();
                                var to = $to.val();
                                var from = $from.val();
                                var price = $price.val();
                                var isLastRow = $this.parent().is(':last-child');
                                if (to == -1 && isLastRow) {

                                } else if (to && parseInt(to) <= parseInt(from)) {
                                    alert ('Giá trị cột Đến m3 phải lớn hơn cột Từ m3');
                                    $to.focus().select();
                                } else if (to && (!$.isNumeric(to) || parseInt(to) < 0)) {
                                    alert('Giá trị nhập vào không hợp lệ');
                                    $to.focus().select();
                                } else if (price && (!$.isNumeric(price) || parseInt(price) < 0)) {
                                    alert('Giá trị nhập vào không hợp lệ');
                                    $price.focus().select();
                                } else {
                                    // change value of From in the next row. From = (last row's To) + 1
                                    var $next = $this.next();
                                    if ($next) {
                                        $next.children('.from').children().val(parseInt(to) + 1);
                                    }
                                }
                            });
                            $('.plus').on('click', function() {
                                $toCell = $('#dialog-update-water-standard').find('.line').last().children('.to').children();
                                to = parseInt($toCell.val());
                                if (to == -1) {
                                    alert('Bạn phải nhập giá trị khác -1 cho cột Đến kW ở dòng cuối cùng trước khi thêm dòng mới')
                                } else {
                                    // select dummy-line
                                    $dummy = $('.dummy-line');
                                    // add a new dummy-line after the default dummy-line, change the default dummy-line into a `line` and make all its children visible
                                    // the new dummy-line become the default dummy-line
                                    $dummy.after($dummy.outerHTML()).removeClass("dummy-line").addClass("line")
                                            .children().show() // show newly added row
                                            .end().children('.from').children().val(to + 1); // From = (last To value) + 1
                                }
                            });
                        }, // for debugging purpose
                        error: function(xhr) {
                            console.log(xhr);
                        }
                    });
                } else {
                    alert('Bạn phải nhập ngày bắt đầu!');
                }
            });

            $('input[name="applyWaterStandard"]').click(function() {
                $('#dialog-apply-water-standard').dialog('open');
            });

            $('#dialog-apply-water-standard').dialog({
                autoOpen: false,
                draggable: true,
                resizable: false,
                position: 'center',
                modal: true,
                show: true,
                minHeight: 'auto', // auto expand height
                minWidth: 'auto',
                buttons: {
                    "Đồng ý": function() {
                        $.ajax({
                            url: 'index.php?route=price/edit/applyWaterStandardPrice&token=<?php echo $token; ?>',
                            data: { 'id' : $('#water_modified_date').children('option').filter(':selected').val() },
                            dataType: 'json',
                            type: 'post',
                            success: function() {
                            },
                            error: function(xhr) {
                                console.log(xhr);
                            }
                        });
                        idApplyingWaterStandardPrice = $('#water_modified_date').children('option').filter(':selected').val();
                        $('#applyingWaterStandardPrice').show();
                        $('input[name="applyWaterStandard"]').prop('disabled', true);
                        $(this).dialog("close");
                    },
                    "Hủy bỏ": function() {
                        $(this).dialog("close");
                    }
                }
            });

            $('#from-date-water').datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function(selectedDate) {
                    var dateFrom = $('#from-date-water').datepicker('getDate');
                    var dateTo = $('#to-date-water').datepicker('getDate');
                    if (dateFrom && dateTo && dateFrom > dateTo) {
                        alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc!');
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                    if (dateFrom < frDate) {
                        alert("Không thể chọn ngày bắt đầu trong quá khứ!");
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                }
            });

            $('#to-date-water').datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function(selectedDate) {
                    var dateFrom = $('#from-date-water').datepicker('getDate');
                    var dateTo = $('#to-date-water').datepicker('getDate');
                    if (dateFrom && dateTo && dateFrom > dateTo) {
                        alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc!');
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                }
            });
            //==========================================================================================================
            $.ajax({
                url: 'index.php?route=price/edit/loadApplyingGarbageStandardId&token=<?php echo $token; ?>',
                dataType: 'json',
                type: 'post',
                success: function(json) {
                    idApplyingGarbageStandardPrice = json['id'];
                    if ($('#garbage_modified_date').children('option').filter(':selected').val() == idApplyingGarbageStandardPrice) {
                        $('#applyingGarbageStandardPrice').show();
                        $('input[name="applyGarbageStandard"]').prop('disabled', true);
                    } else {
                        $('#applyingGarbageStandardPrice').hide();
                        $('input[name="applyGarbageStandard"]').prop('disabled', false);
                    }
                },
                error: function(xhr) {
                    console.log(xhr);
                }
            });

            $('#garbage_modified_date').change(function() {
                var $btnCreateNew = $('input[name="createNewGarbageStandard"]');
                var $fromDate = $('#from-date-garbage');
                var $toDate = $('#to-date-garbage');
                if ($(this).children('option').filter(':selected').val() == idApplyingGarbageStandardPrice) {
                    $('#applyingGarbageStandardPrice').show();
                    $('input[name="applyGarbageStandard"]').prop('disabled', true);
                } else {
                    $('#applyingGarbageStandardPrice').hide();
                    $('input[name="applyGarbageStandard"]').prop('disabled', false);
                }
                $.blockUI({ message: '<h3><span><img src="view/image/price/preloader.gif" height="16" width="16" /></span> Đang tải dữ liệu...</h3>' });
                $.ajax({
                    url: 'index.php?route=price/edit/loadGarbageStandardPrice&token=<?php echo $token; ?>',
                    data: { 'id' : $(this).children('option').filter(':selected').val() },
                    dataType: 'json',
                    type: 'post',
                    success: function(json) {
                        var $show = $('.standard_price_show').children('.garbage_standard_price').find('tbody');
                        var $edit = $('.standard_price_edit').find('.garbage_standard_price').find('tbody');
                        // delete all current lines in the table
                        $show.empty();
                        $edit.empty();
                        // loop all elements in a list of objects
                        for (var index in json['data']) {
                            var price = parseInt(json['data'][index]['Price']);
                            // add new lines represent the standard price corresponding to the inputted date
                            $show.append('<tr class="line">' +
                                    '<td class="price">' + price.format() + '&nbsp₫</td>' + // format function: convert 1234 -> 1,234
                                    '</tr>');
                            $edit.append('<tr class="line">' +
                                    '<td class="price">' + price.format() + '&nbsp₫</td>' + // format function: convert 1234 -> 1,234
                                    '</tr>');
                        }
                    }, // for debugging purpose
                    error: function(xhr) {
                        console.log(xhr);
                    }
                });
            });

            $('#dialog-update-garbage-standard').dialog({
                autoOpen: false,
                draggable: false,
                resizable: false,
                position: 'center',
                modal: true,
                show: true,
                minHeight: 'auto', // auto expand height
                minWidth: 'auto',
                dialogClass: 'dlg-no-title',
                buttons: {
                    "Cập nhật": function() {
                        var $this = $(this);
                        // check that all cells are inputted
                        var checkFill = true;
                        $('#dialog-update-garbage-standard input').each(function(i, e) {
                            if ($(e).parent().parent().hasClass('line') && $(e).val() == '') {
                                checkFill = false;
                                return false;
                            }
                        });
                        var $lastRow = $('#dialog-update-garbage-standard').find('.line').last();
                        var price = $lastRow.children('.price').children().val();
                        if (price) {
                            jsonGarbageNew.garbage_new = {};
                            $('#dialog-update-garbage-standard').find('.line').each(function(index, element) {
                                jsonGarbageNew.garbage_new[index] = {};
                                jsonGarbageNew.garbage_new[index].price = $(element).children('.price').children().val();
                            });
                            var updateDateTo = '';
                            var frDate = $('#from-date-garbage').val();
                            var updateDateFrom = frDate.substr(6, 4) + '-' + frDate.substr(3, 2) + '-' + frDate.substr(0, 2);
                            if ($('#to-date-garbage').val()) {
                                var toDate = $('#to-date-garbage').val();
                                updateDateTo = toDate.substr(6, 4) + '-' + toDate.substr(3, 2) + '-' + toDate.substr(0, 2);
                            }
                            $.ajax({
                                url: 'index.php?route=price/edit/updateGarbageStandardPrice&token=<?php echo $token; ?>',
                                data: {
                                    'garbage_new_data': jsonGarbageNew,
                                    'update_date_from': updateDateFrom,
                                    'update_date_to': updateDateTo,
                                    'id': idNewestGarbage
                                },
                                dataType: 'json',
                                type: 'post',
                                success: function(json) {
                                    var arr = jsonGarbageNew.water_new;
                                    var $show = $('.standard_price_show').children('.garbage_standard_price').find('tbody');
                                    var $edit = $('.standard_price_edit').find('.garbage_standard_price').find('tbody');
                                    $show.empty();
                                    $edit.empty();
                                    for (var index in arr) {
                                        var price = parseInt(arr[index].price);
                                        $show.append('<tr class="line">' +
                                                '<td class="price">' + price.format() + '&nbsp₫</td>' +
                                                '</tr>');
                                        $edit.append('<tr class="line">' +
                                                '<td class="price">' + price.format() + '&nbsp₫</td>' +
                                                '</tr>');
                                    }
                                    $this.dialog('close');
                                }, // for debugging purpose
                                error: function(xhr) {
                                    console.log(xhr);
                                }
                            });
                        } else {
                            alert('Bạn chưa nhập đủ dữ liệu');
                        }
                    },
                    "Hủy bỏ": function() {
                        $( this ).dialog( "close" );
                    }
                }
            });

            $('input[name="createNewGarbageStandard"]').click(function() {
                if ($('#from-date-garbage').val()) {
                    var $tbody = $('#dialog-update-garbage-standard').find('tbody');
                    $tbody.empty();
                    // jQuery BlockUI (http://malsup.com/jquery/block/)
                    $.blockUI({ message: '<h3><span><img src="view/image/price/preloader.gif" height="16" width="16" /></span> Đang lấy dữ liệu...</h3>' });
                    $.ajax({
                        url: 'index.php?route=price/edit/loadNewestGarbageStandardPrice&token=<?php echo $token; ?>',
                        dataType: 'json',
                        type: 'post',
                        success: function(json) {
                            // open dialog after loading data successfully
                            $('#dialog-update-garbage-standard').dialog('open');
                            idNewestGarbage = json['id'];
                            for (var index in json['newest']) {
                                if (index == 0) {
                                    $tbody.append('<tr class="line">' +
                                            '<td class="price"><input type="text" style="width: 74px;" value="' + json['newest'][index]['Price'] + '"/></td>' +
                                            '</tr>');
                                } else {
                                    $tbody.append('<tr class="line">' +
                                            '<td class="price"><input type="text" style="width: 74px;" value="' + json['newest'][index]['Price'] + '"/></td>' +
                                            '</tr>');
                                }
                            }
                            $tbody.append('' +
                                    '<tr class="dummy-line">' +
                                    '<td class="price" style="display: none;"><input style="width: 74px;" /></td>' +
                                    '</tr>');
                            // input check
                            $('#dialog-update-garbage-standard').find('tbody').focusout(function(e) { // e: event object
                                var $this = $(e.target).closest('.line'); // e.target points to the focus-lost element
                                var $price = $this.children('.price').children();
                                var price = $price.val();
                                if (price && (!$.isNumeric(price) || parseInt(price) < 0)) {
                                    alert('Giá trị nhập vào không hợp lệ');
                                    $price.focus().select();
                                }
                            });
                        }, // for debugging purpose
                        error: function(xhr) {
                            console.log(xhr);
                        }
                    });
                } else {
                    alert('Bạn phải nhập ngày bắt đầu!');
                }
            });

            $('input[name="applyGarbageStandard"]').click(function() {
                $('#dialog-apply-garbage-standard').dialog('open');
            });

            $('#dialog-apply-garbage-standard').dialog({
                autoOpen: false,
                draggable: true,
                resizable: false,
                position: 'center',
                modal: true,
                show: true,
                minHeight: 'auto', // auto expand height
                minWidth: 'auto',
                buttons: {
                    "Đồng ý": function() {
                        $.ajax({
                            url: 'index.php?route=price/edit/applyGarbageStandardPrice&token=<?php echo $token; ?>',
                            data: { 'id' : $('#garbage_modified_date').children('option').filter(':selected').val() },
                            dataType: 'json',
                            type: 'post',
                            success: function() {
                            },
                            error: function(xhr) {
                                console.log(xhr);
                            }
                        });
                        idApplyingGarbageStandardPrice = $('#garbage_modified_date').children('option').filter(':selected').val();
                        $('#applyingGarbageStandardPrice').show();
                        $('input[name="applyGarbageStandard"]').prop('disabled', true);
                        $(this).dialog("close");
                    },
                    "Hủy bỏ": function() {
                        $(this).dialog("close");
                    }
                }
            });

            $('#from-date-garbage').datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function(selectedDate) {
                    var dateFrom = $('#from-date-garbage').datepicker('getDate');
                    var dateTo = $('#to-date-garbage').datepicker('getDate');
                    if (dateFrom && dateTo && dateFrom > dateTo) {
                        alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc!');
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                    if (dateFrom < frDate) {
                        alert("Không thể chọn ngày bắt đầu trong quá khứ!");
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                }
            });

            $('#to-date-garbage').datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function(selectedDate) {
                    var dateFrom = $('#from-date-garbage').datepicker('getDate');
                    var dateTo = $('#to-date-garbage').datepicker('getDate');
                    if (dateFrom && dateTo && dateFrom > dateTo) {
                        alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc!');
                        if (!$(this).hasClass('invalid')) {
                            $(this).removeClass('valid');
                            $(this).addClass('invalid');
                        }
                    } else {
                        if (!$(this).hasClass('valid')) {
                            $(this).removeClass('invalid');
                            $(this).addClass('valid');
                        }
                    }
                }
            });
            var frDate = new Date();
            //var updateDateFrom = frDate.substr(6, 4) + '-' + frDate.substr(3, 2) + '-' + frDate.substr(0, 2);
        });
    </script>
</head>
<div id="content">
    <div class="standard_price_show">
        <h2>BẢNG GIÁ ĐIỆN - NƯỚC</h2>
        <?php echo '<h3>' . $description_electricity . '</h3>'; ?>
        <table class="electricity_standard_price">
            <thead>
                <td><b><?php echo $text_electricity_from; ?></b></td>
                <td><b><?php echo $text_electricity_to; ?></b></td>
                <td><b><?php echo $text_electricity_price; ?></b</td>
            </thead>
            <tbody>
            <?php
                if ($e_standard) {
                    foreach ($e_standard as $row) {
                ?>
            <tr class="line">
                <td class="from"><?php echo $row['From']; ?></td>
                <td class="to"><?php if ($row['To'] != '-1') echo $row['To']; ?></td>
                <td class="price"><?php echo number_format($row['Price']); ?>&nbsp₫</td>
            </tr>
            <?php
                    }
                }
                ?>
            </tbody>
        </table>
        <br /><br />
        <?php echo '<h3>' . $description_water . '</h3>'; ?>
        <table class="water_standard_price">
            <thead>
                <td><b><?php echo $text_water_from; ?></b></td>
                <td><b><?php echo $text_water_to; ?></b></td>
                <td><b><?php echo $text_water_price; ?></b></td>
            </thead>
            <tbody>
            <?php
                if ($w_standard) {
                    foreach ($w_standard as $row) {
                ?>
            <tr class="line">
                <td class="from"><?php echo $row['From']; ?></td>
                <td class="to"><?php if ($row['To'] != '-1') echo $row['To']; ?></td>
                <td class="price"><?php echo number_format($row['Price']); ?>&nbsp₫</td>
            </tr>
            <?php
                    }
                }
                ?>
            </tbody>
        </table>
        <br /><br />
        <?php echo '<h3>' . $description_garbage . '</h3>'; ?>
        <table class="garbage_standard_price">
            <thead>
            <td><b><?php echo $text_electricity_price; ?></b</td>
            </thead>
            <tbody>
            <?php
                if ($g_standard) {
                    foreach ($g_standard as $row) {
                ?>
            <tr class="line">
                <td class="price"><?php echo number_format($row['Price']); ?>&nbsp₫</td>
            </tr>
            <?php
                    }
                }
                ?>
            </tbody>
        </table>
        <br /><br />
    </div>
    <div class="standard_price_edit" style="overflow: auto;">
        <h2>CHỈNH SỬA ĐỊNH MỨC GIÁ ĐIỆN - NƯỚC</h2>
        <div class="table_electricity">
            <?php echo '<h3>' . $description_electricity . '</h3>'; ?>
            <div id="dialog-update-electricity-standard" title="Cập nhật">
                <p><span style="color: red; font-weight: bold;">(*)</span> Nhập -1 vào cột Đến kW để kết thúc bảng định mức</p>
                <table>
                    <thead>
                        <td><b><?php echo $text_electricity_from; ?></b></td>
                        <td><b><?php echo $text_electricity_to; ?></b></td>
                        <td><b><?php echo $text_electricity_price; ?></b</td>
                        <td></td>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div>
                <?php echo $last_modified; ?>
                <select id="electricity_modified_date">
                    <?php
                    foreach ($electricity_last_modified_list as $row) {
                    $from = date("d-m-Y", strtotime($row['from']));
                    if (!empty($row['to'])) {
                        $to = date("d-m-Y", strtotime($row['to']));
                  ?>
                    <option value="<?php echo $row['id']; ?>"><?php echo $from; ?> -> <?php echo $to; ?></option>
                    <?php
                    } else {
                  ?>
                    <option value="<?php echo $row['id']; ?>"><?php echo $from; ?></option>
                    <?php
                    }
                  ?>
                    ?>
                    <?php } ?>
                </select>
                <input type="button" value="ÁP DỤNG" name="applyElectricityStandard" style="float: none;" />
            </div>
            <div id="dialog-apply-electricity-standard" title="Áp dụng">
                <p>Bạn có muốn áp dụng định mức này?</p>
            </div>

            <div style="clear: both;"></div>
            <div style="width: 200px;">
                <div><p><?php echo $from_date; ?></p><input type="text" id="from-date-electricity"></div>
                <div style="clear: both;"></div>
                <div><p><?php echo $to_date; ?></p><input type="text" id="to-date-electricity"></div>
                <div style="clear: both;"></div>
            </div>
            <input type="button" value="CẬP NHẬT" name="createNewElectricityStandard" style="float: none;" />
            <div class="left_info">
                <p id="applyingElectricityStandardPrice" style="display: none;"><span style="color: #ff0000;">(*)</span> Định mức đang áp dụng</p>
                <table class="electricity_standard_price">
                    <thead>
                        <td><b><?php echo $text_electricity_from; ?></b></td>
                        <td><b><?php echo $text_electricity_to; ?></b></td>
                        <td><b><?php echo $text_electricity_price; ?></b</td>
                    </thead>
                    <tbody>
                    <?php
                        if ($e_standard) {
                            foreach ($e_standard as $row) {
                        ?>
                    <tr class="line">
                        <td class="from"><?php echo $row['From']; ?></td>
                        <td class="to"><?php if ($row['To'] != -1) echo $row['To']; ?></td>
                        <td class="price"><?php echo number_format($row['Price']); ?>&nbsp₫</td>
                    </tr>
                    <?php
                            }
                        }
                        ?>
                    </tbody>
                </table>
                <br /><br />
            </div>
        </div>
        <div class="table_water">
            <?php echo '<h3>' . $description_water . '</h3>'; ?>
            <div id="dialog-update-water-standard" title="Cập nhật">
                <p><span style="color: red; font-weight: bold;">(*)</span> Nhập -1 vào cột Đến kW để kết thúc bảng định mức</p>
                <table>
                    <thead>
                        <td><b><?php echo $text_water_from; ?></b></td>
                        <td><b><?php echo $text_water_to; ?></b></td>
                        <td><b><?php echo $text_water_price; ?></b</td>
                        <td></td>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div>
                <?php echo $last_modified; ?>
                <select id="water_modified_date">
                    <?php
                    foreach ($water_last_modified_list as $row) {
                    $from = date("d-m-Y", strtotime($row['from']));
                    if (!empty($row['to'])) {
                        $to = date("d-m-Y", strtotime($row['to']));
                  ?>
                    <option value="<?php echo $row['id']; ?>"><?php echo $from; ?> -> <?php echo $to; ?></option>
                    <?php
                    } else {
                  ?>
                    <option value="<?php echo $row['id']; ?>"><?php echo $from; ?></option>
                    <?php
                    }
                  ?>
                    ?>
                    <?php } ?>
                </select>
                <input type="button" value="ÁP DỤNG" name="applyWaterStandard" style="float: none;" />
            </div>
            <div id="dialog-apply-water-standard" title="Áp dụng">
                <p>Bạn có muốn áp dụng định mức này?</p>
            </div>

            <div style="clear: both;"></div>
            <div style="width: 200px;">
                <div><p><?php echo $from_date; ?></p><input type="text" id="from-date-water"></div>
                <div style="clear: both;"></div>
                <div><p><?php echo $to_date; ?></p><input type="text" id="to-date-water"></div>
                <div style="clear: both;"></div>
            </div>
            <input type="button" value="CẬP NHẬT" name="createNewWaterStandard" style="float: none;" />
            <div class="left_info">
                <p id="applyingWaterStandardPrice" style="display: none;"><span style="color: #ff0000;">(*)</span> Định mức đang áp dụng</p>
                <table class="water_standard_price">
                    <thead>
                    <td><b><?php echo $text_water_from; ?></b></td>
                    <td><b><?php echo $text_water_to; ?></b></td>
                    <td><b><?php echo $text_water_price; ?></b</td>
                    </thead>
                    <tbody>
                    <?php
                        if ($w_standard) {
                            foreach ($w_standard as $row) {
                        ?>
                    <tr class="line">
                        <td class="from"><?php echo $row['From']; ?></td>
                        <td class="to"><?php if ($row['To'] != -1) echo $row['To']; ?></td>
                        <td class="price"><?php echo number_format($row['Price']); ?>&nbsp₫</td>
                    </tr>
                    <?php
                            }
                        }
                        ?>
                    </tbody>
                </table>
                <br /><br />
            </div>
        </div>
        <div class="table_garbage">
            <?php echo '<h3>' . $description_garbage . '</h3>'; ?>
            <div id="dialog-update-garbage-standard" title="Cập nhật">
                <table>
                    <thead>
                        <td><b><?php echo $text_garbage_price; ?></b</td>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div>
                <?php echo $last_modified; ?>
                <select id="garbage_modified_date">
                    <?php
                    foreach ($garbage_last_modified_list as $row) {
                    $from = date("d-m-Y", strtotime($row['from']));
                    if (!empty($row['to'])) {
                        $to = date("d-m-Y", strtotime($row['to']));
                  ?>
                    <option value="<?php echo $row['id']; ?>"><?php echo $from; ?> -> <?php echo $to; ?></option>
                    <?php
                    } else {
                  ?>
                    <option value="<?php echo $row['id']; ?>"><?php echo $from; ?></option>
                    <?php
                    }
                  ?>
                    ?>
                    <?php } ?>
                </select>
                <input type="button" value="ÁP DỤNG" name="applyGarbageStandard" style="float: none;" />
            </div>
            <div id="dialog-apply-garbage-standard" title="Áp dụng">
                <p>Bạn có muốn áp dụng định mức này?</p>
            </div>

            <div style="clear: both;"></div>
            <div style="width: 200px;">
                <div><p><?php echo $from_date; ?></p><input type="text" id="from-date-garbage"></div>
                <div style="clear: both;"></div>
                <div><p><?php echo $to_date; ?></p><input type="text" id="to-date-garbage"></div>
                <div style="clear: both;"></div>
            </div>
            <input type="button" value="CẬP NHẬT" name="createNewGarbageStandard" style="float: none;" />
            <div class="left_info">
                <p id="applyingGarbageStandardPrice" style="display: none;"><span style="color: #ff0000;">(*)</span> Định mức đang áp dụng</p>
                <table class="garbage_standard_price">
                    <thead>
                    <td><b><?php echo $text_garbage_price; ?></b</td>
                    </thead>
                    <tbody>
                    <?php
                        if ($g_standard) {
                            foreach ($g_standard as $row) {
                        ?>
                    <tr class="line">
                        <td class="price"><?php echo number_format($row['Price']); ?>&nbsp₫</td>
                    </tr>
                    <?php
                            }
                        }
                        ?>
                    </tbody>
                </table>
                <br /><br />
            </div>
        </div>
    </div>
</div>
<?php echo $footer; ?>