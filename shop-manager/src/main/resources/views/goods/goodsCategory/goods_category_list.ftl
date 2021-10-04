<!-- 设置项目根路径全局变量 -->
<#assign ctx=request.contextPath/>
<script type="text/javascript">
    var ctx = "${ctx}";
</script>
<html>
<head>
    <meta charset="UTF-8">
    <title>ego管理后台</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Bootstrap 3.3.4 -->
    <link href="${ctx}/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <!-- FontAwesome 4.3.0 -->
    <link href="${ctx}/bootstrap/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>

    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css"/>

    <link href="${ctx}/dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css"/>
    <!-- AdminLTE Skins. Choose a skin from the css/skins 
    	folder instead of downloading all of them to reduce the load. -->
    <link href="${ctx}/dist/css/skins/_all-skins.min.css" rel="stylesheet" type="text/css"/>
    <!-- iCheck -->
    <link href="${ctx}/plugins/iCheck/flat/blue.css" rel="stylesheet" type="text/css"/>
    <!-- jQuery 2.1.4 -->
    <script src="${ctx}/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="${ctx}/js/global.js"></script>
    <script src="${ctx}/js/myFormValidate.js"></script>
    <script src="${ctx}/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="${ctx}/js/layer/layer-min.js"></script><!-- 弹窗js 参考文档 http://layer.layui.com/-->
    <script src="${ctx}/js/myAjax.js"></script>
    <script type="text/javascript">
        function delfunc(obj) {
            layer.confirm('确认删除？', {
                    btn: ['确定', '取消'] //按钮
                }, function () {
                    $.ajax({
                        type: 'post',
                        url: $(obj).attr('data-url'),
                        data: {act: 'del', del_id: $(obj).attr('data-id')},
                        dataType: 'json',
                        success: function (data) {
                            if (data == 1) {
                                layer.msg('操作成功', {icon: 1});
                                $(obj).parent().parent().remove();
                            } else {
                                layer.msg(data, {icon: 2, time: 2000});
                            }
                            layer.closeAll();
                        }
                    })
                }, function (index) {
                    layer.close(index);
                    return false;// 取消
                }
            );
        }

        //全选
        function selectAll(name, obj) {
            $('input[name*=' + name + ']').prop('checked', $(obj).checked);
        }

        function get_help(obj) {
            layer.open({
                type: 2,
                title: '帮助手册',
                shadeClose: true,
                shade: 0.3,
                area: ['90%', '90%'],
                content: $(obj).attr('data-url'),
            });
        }

        function delAll(obj, name) {
            var a = [];
            $('input[name*=' + name + ']').each(function (i, o) {
                if ($(o).is(':checked')) {
                    a.push($(o).val());
                }
            })
            if (a.length == 0) {
                layer.alert('请选择删除项', {icon: 2});
                return;
            }
            layer.confirm('确认删除？', {btn: ['确定', '取消']}, function () {
                    $.ajax({
                        type: 'get',
                        url: $(obj).attr('data-url'),
                        data: {act: 'del', del_id: a},
                        dataType: 'json',
                        success: function (data) {
                            if (data == 1) {
                                layer.msg('操作成功', {icon: 1});
                                $('input[name*=' + name + ']').each(function (i, o) {
                                    if ($(o).is(':checked')) {
                                        $(o).parent().parent().remove();
                                    }
                                })
                            } else {
                                layer.msg(data, {icon: 2, time: 2000});
                            }
                            layer.closeAll();
                        }
                    })
                }, function (index) {
                    layer.close(index);
                    return false;// 取消
                }
            );
        }
    </script>
    <meta name="__hash__" content="de25d42444751b4d059ec9006eb4ebb9_18e7b463027ae778e1bc48f3dec702d7"/>
</head>
<body style="background-color:#ecf0f5;">


<div class="wrapper">
    <div class="breadcrumbs" id="breadcrumbs">
        <ol class="breadcrumb">
            <li><a href="javascript:void();"><i class="fa fa-home"></i>&nbsp;&nbsp;后台首页</a></li>

            <li><a href="javascript:void();">商品管理</a></li>
            <li><a href="javascript:void();">商品分类</a></li>
        </ol>
    </div>

    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-header">
                        <nav class="navbar navbar-default">
                            <div class="collapse navbar-collapse">
                                <div class="navbar-form row">
                                    <div class="col-md-1">
                                        <button class="btn bg-navy" type="button" onclick="tree_open(this);"><i
                                                    class="fa fa-angle-double-down"></i>展开
                                        </button>
                                    </div>
                                    <div class="col-md-9">
                                        <span class="warning">温馨提示：顶级分类（一级大类）设为推荐时才会在首页楼层中显示</span>
                                    </div>
                                    <div class="col-md-2">
                                        <a href="${ctx}/goodsCategory/addPage" class="btn btn-primary pull-right"><i
                                                    class="fa fa-plus"></i>新增分类</a>
                                    </div>
                                </div>
                            </div>
                        </nav>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="row">
                            <div class="col-sm-12">
                                <table id="list-table" class="table table-bordered table-striped dataTable" role="grid"
                                       aria-describedby="example1_info">
                                    <thead>
                                    <tr role="row">
                                        <th valign="middle">分类ID</th>
                                        <th valign="middle">分类名称</th>
                                        <th valign="middle">手机显示名称</th>
                                        <th valign="middle">是否推荐</th>
                                        <th valign="middle">是否显示</th>
                                        <th valign="middle">分组</th>
                                        <th valign="middle">排序</th>
                                        <th valign="middle">操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <#list gcvList as gcv01>
                                        <tr role="row" align="center" class="1" id="1_1">
                                            <td>${gcv01.id}</td>
                                            <td align="left" style="padding-left:5em">
                                                <span class="glyphicon glyphicon-plus btn-warning"
                                                      style="padding:2px; font-size:12px;" id="icon_1_1" aria-hidden="false"
                                                      onclick="rowClicked(this)"></span>&nbsp; <span>${(gcv01.name)!""}</span>
                                            </td>
                                            <td><span>${(gcv01.mobileName)!""}</span></td>
                                            <td>
                                                <#if gcv01.isHot==1>
                                                        <img width="20" height="20" src="${ctx}/images/yes.png"
                                                            onclick="changeTableVal('goods_category','id','1','is_hot',this)"/>
                                                    <#else>
                                                        <img width="20" height="20" src="${ctx}/images/cancel.png"
                                                             onclick="changeTableVal('goods_category','id','1','is_hot',this)"/>
                                                </#if>

                                            </td>
                                            <td>
                                                <#if gcv01.isShow==1>
                                                    <img width="20" height="20" src="${ctx}/images/yes.png"
                                                         onclick="changeTableVal('goods_category','id','1','is_hot',this)"/>
                                                <#else>
                                                    <img width="20" height="20" src="${ctx}/images/cancel.png"
                                                         onclick="changeTableVal('goods_category','id','1','is_hot',this)"/>
                                                </#if>
                                            </td>
                                            <td>
                                                <input type="text"
                                                       onchange="updateSort('goods_category','id','1','cat_group',this)"
                                                       onkeyup="this.value=this.value.replace(/[^\d]/g,'')"
                                                       onpaste="this.value=this.value.replace(/[^\d]/g,'')" size="4"
                                                       value="${(gcv01.catGroup)!""}" class="input-sm"/>
                                            </td>
                                            <td>
                                                <input type="text"
                                                       onchange="updateSort('goods_category','id','1','sort_order',this)"
                                                       onkeyup="this.value=this.value.replace(/[^\d]/g,'')"
                                                       onpaste="this.value=this.value.replace(/[^\d]/g,'')" size="4"
                                                       value="${(gcv01.sortOrder)!""}" class="input-sm"/>
                                            </td>
                                            <td>
                                                <a class="btn btn-primary" href="商品分类-编辑.html"><i class="fa fa-pencil">
                                                    </i></a>
                                                <a class="btn btn-danger"
                                                   href="javascript:del_GoodsCatorie(${(gcv01.id)!""});"><i
                                                            class="fa fa-trash-o"></i></a>
                                            </td>
                                        </tr>
                                        <#if gcv01.children??>
                                            <#list gcv01.children as gcv02>
                                                <tr role="row" align="center" class="2" id="2_12" style="display:none">
                                                    <td>${gcv02.id}</td>
                                                    <td align="left" style="padding-left:10em">
                                                <span class="glyphicon glyphicon-plus btn-warning"
                                                      style="padding:2px; font-size:12px;" id="icon_2_12"
                                                      aria-hidden="false" onclick="rowClicked(this)"></span>&nbsp; <span>${(gcv02.name)!""}</span>
                                                    </td>
                                                    <td><span>${(gcv02.mobileName)!""}</span></td>
                                                    <td>
                                                        <img width="20" height="20" src="${ctx}/images/cancel.png"
                                                             onclick="changeTableVal('goods_category','id','12','is_hot',this)"/>
                                                    </td>
                                                    <td>
                                                        <img width="20" height="20" src="${ctx}/images/yes.png"
                                                             onclick="changeTableVal('goods_category','id','12','is_show',this)"/>
                                                    </td>
                                                    <td>
                                                        <input type="text"
                                                               onchange="updateSort('goods_category','id','12','cat_group',this)"
                                                               onkeyup="this.value=this.value.replace(/[^\d]/g,'')"
                                                               onpaste="this.value=this.value.replace(/[^\d]/g,'')" size="4"
                                                               value="${(gcv02.sortOrder)!""}" class="input-sm"/>
                                                    </td>
                                                    <td>
                                                        <input type="text"
                                                               onchange="updateSort('goods_category','id','12','sort_order',this)"
                                                               onkeyup="this.value=this.value.replace(/[^\d]/g,'')"
                                                               onpaste="this.value=this.value.replace(/[^\d]/g,'')" size="4"
                                                               value="${(gcv02.catGroup)!""}" class="input-sm"/>
                                                    </td>
                                                    <td>
                                                        <a class="btn btn-primary"
                                                           href="/index/Admin/Goods/addEditCategory/id/12"><i
                                                                    class="fa fa-pencil"></i></a>
                                                        <a class="btn btn-danger"
                                                           href="javascript:del_GoodsCatorie(${(gcv02.id)!""});"><i
                                                                    class="fa fa-trash-o"></i></a>
                                                    </td>
                                                </tr>
                                                <#if gcv02.children??>
                                                    <#list gcv02.children as gcv03>
                                                        <tr role="row" align="center" class="3" id="3_100" style="display:none">
                                                            <td>${gcv03.id}</td>
                                                            <td align="left" style="padding-left:15em">
                                                                <span>${(gcv03.name)!""}</span>
                                                            </td>
                                                            <td><span>${(gcv03.mobileName)!""}</span></td>
                                                            <td>
                                                                <img width="20" height="20" src="${ctx}/images/cancel.png"
                                                                     onclick="changeTableVal('goods_category','id','100','is_hot',this)"/>
                                                            </td>
                                                            <td>
                                                                <img width="20" height="20" src="${ctx}/images/yes.png"
                                                                     onclick="changeTableVal('goods_category','id','100','is_show',this)"/>
                                                            </td>
                                                            <td>
                                                                <input type="text"
                                                                       onchange="updateSort('goods_category','id','100','cat_group',this)"
                                                                       onkeyup="this.value=this.value.replace(/[^\d]/g,'')"
                                                                       onpaste="this.value=this.value.replace(/[^\d]/g,'')" size="4"
                                                                       value="${(gcv03.catGroup)!""}" class="input-sm"/>
                                                            </td>
                                                            <td>
                                                                <input type="text"
                                                                       onchange="updateSort('goods_category','id','100','sort_order',this)"
                                                                       onkeyup="this.value=this.value.replace(/[^\d]/g,'')"
                                                                       onpaste="this.value=this.value.replace(/[^\d]/g,'')" size="4"
                                                                       value="${(gcv03.sortOrder)!""}" class="input-sm"/>
                                                            </td>
                                                            <td>
                                                                <a class="btn btn-primary" href="/index/Admin/Goods/addEditCategory/id/100"><i
                                                                            class="fa fa-pencil"></i></a>
                                                                <a class="btn btn-danger" href="javascript:" onclick="del_GoodsCatorie(${(gcv03.id)});"  ><i
                                                                            class="fa fa-trash-o"></i></a>
                                                            </td>
                                                        </tr>
                                                    </#list>
                                                </#if>
                                            </#list>
                                        </#if>
                                    </#list>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <div class="dataTables_info" id="example1_info" role="status" aria-live="polite">分页
                                </div>
                            </div>
                        </div>
                    </div><!-- /.box-body -->
                </div><!-- /.box -->
            </div>
        </div>
    </section>
</div>
<script type="text/javascript">

    // 展开收缩
    function tree_open(obj) {
        var tree = $('#list-table tr[id^="2_"], #list-table tr[id^="3_"] '); //,'table-row'
        if (tree.css('display') == 'table-row') {
            $(obj).html("<i class='fa fa-angle-double-down'></i>展开");
            tree.css('display', 'none');
            $("span[id^='icon_']").removeClass('glyphicon-minus');
            $("span[id^='icon_']").addClass('glyphicon-plus');
        } else {
            $(obj).html("<i class='fa fa-angle-double-up'></i>收缩");
            tree.css('display', 'table-row');
            $("span[id^='icon_']").addClass('glyphicon-minus');
            $("span[id^='icon_']").removeClass('glyphicon-plus');
        }
    }

    // 以下是 bootstrap 自带的  js
    function rowClicked(obj) {
        span = obj;

        obj = obj.parentNode.parentNode;

        var tbl = document.getElementById("list-table");

        var lvl = parseInt(obj.className);

        var fnd = false;

        var sub_display = $(span).hasClass('glyphicon-minus') ? 'none' : '' ? 'block' : 'table-row';
        //console.log(sub_display);
        if (sub_display == 'none') {
            $(span).removeClass('glyphicon-minus btn-info');
            $(span).addClass('glyphicon-plus btn-warning');
        } else {
            $(span).removeClass('glyphicon-plus btn-info');
            $(span).addClass('glyphicon-minus btn-warning');
        }

        for (i = 0; i < tbl.rows.length; i++) {
            var row = tbl.rows[i];

            if (row == obj) {
                fnd = true;
            } else {
                if (fnd == true) {
                    var cur = parseInt(row.className);
                    var icon = 'icon_' + row.id;
                    if (cur > lvl) {
                        row.style.display = sub_display;
                        if (sub_display != 'none') {
                            var iconimg = document.getElementById(icon);
                            $(iconimg).removeClass('glyphicon-plus btn-info');
                            $(iconimg).addClass('glyphicon-minus btn-warning');
                        } else {
                            $(iconimg).removeClass('glyphicon-minus btn-info');
                            $(iconimg).addClass('glyphicon-plus btn-warning');
                        }
                    } else {
                        fnd = false;
                        break;
                    }
                }
            }
        }

        for (i = 0; i < obj.cells[0].childNodes.length; i++) {
            var imgObj = obj.cells[0].childNodes[i];
            if (imgObj.tagName == "IMG") {
                if ($(imgObj).hasClass('glyphicon-plus btn-info')) {
                    $(imgObj).removeClass('glyphicon-plus btn-info');
                    $(imgObj).addClass('glyphicon-minus btn-warning');
                } else {
                    $(imgObj).removeClass('glyphicon-minus btn-warning');
                    $(imgObj).addClass('glyphicon-plus btn-info');
                }
            }
        }

    }
    function del_GoodsCatorie(id){
        console.log("123"),
            $.ajax({
                type: 'get',
                url: ctx+"/goodsCategory/deleteGoodsCatorie",
                data: id,
                dataType: "text",
                success: function (data) {
                    if (data == 1) {
                        layer.msg('操作成功', {icon: 1});
                        $(obj).parent().parent().remove();
                    } else {
                        layer.msg(data, {icon: 2, time: 2000});
                    }
                    layer.closeAll();
                }

        })
    }



</script>
</body>
</html>