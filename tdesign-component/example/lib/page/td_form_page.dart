import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDFormPage extends StatefulWidget {
  const TDFormPage({Key? key}) : super(key: key);

  @override
  _TDFormPageState createState() => _TDFormPageState();
}

class _TDFormPageState extends State<TDFormPage> {
  var _controller = [];
  String _selected_1 = '';

  /// form 禁用的状态
  bool _formDisableState = false;

  /// form 排列方式是否为水平
  bool _isFormHorizontal = true;

  /// 控制是否进行表单校验
  bool _validateForm = false;

  /// 设置按钮是否可点击状态
  /// true 表示处于 active 状态
  bool horizontalButton = false;
  bool verticalButton = true;

  Color activeButtonColor = Color(0xFFF0F1FD);
  Color defaultButtonColor = Color(0xFFE5E5E5);

  Color verticalTextColor = Color(0xFF1A1A1A);
  Color horizontalTextColor = Color(0xFF0A58D9);
  Color verticalButtonColor = Color(0xFFE5E5E5);
  Color horizontalButtonColor = Color(0xFFF0F1FD);

  /// radios 传入参数
  final Map<String, String> _radios = {'0': '男', '1': '女', '3': '保密'};

  /// 级联选择器 传入参数
  static const List<Map> _data = [
    {
      'label': '北京市',
      'value': '110000',
      "children": [
        {
          "value": '110100',
          "label": '北京市',
          "children": [
            {"value": '110101', "label": '东城区'},
            {"value": '1101022', "label": '东区'},
            {"value": '110102', "label": '西城区'},
            {"value": '110105', "label": '朝阳区'},
            {"value": '110106', "label": '丰台区'},
            {"value": '110107', "label": '石景山区'},
            {"value": '110108', "label": '海淀区'},
            {"value": '110109', "label": '门头沟区'},
          ],
        },
      ],
    },
    {
      "label": '天津市',
      "value": '120000',
      "children": [
        {
          "value": '120100',
          "label": '天津市',
          "children": [
            {
              "value": '120101',
              "label": '和平区',
            },
            {
              "value": '120102',
              "label": '河东区',
            },
            {
              "value": '120103',
              "label": '河西区',
            },
            {
              "value": '120104',
              "label": '南开区',
            },
            {
              "value": '120105',
              "label": '河北区',
            },
            {
              "value": '120106',
              "label": '红桥区',
            },
            {
              "value": '120110',
              "label": '东丽区',
            },
            {
              "value": '120111',
              "label": '西青区',
            },
            {
              "value": '120112',
              "label": '津南区',
            },
          ],
        },
      ],
    },
  ];

  /// 整个表单存放的数据
  List<dynamic> _formData = [];

  void _updateFormData(

      /// type: 表格单元类型  num: 重复的类型的表格单元的序号  value：表格单元存放的数据
      {required TDFormItemType type,
      int num = 0,
      required value}) {
    final existingIndex = _formData.indexWhere(
      (element) => element['itemType'] == type && element['num'] == num,
    );
    if (existingIndex != -1) {
      _formData[existingIndex]['value'] = value;
    } else {
      _formData.add({'itemType': type, 'num': num, 'value': value});
    }
  }

  /// TDDateTimePicker 监控数据
  void _dateONChange(newValue) {
    print('Date value changed to $newValue');
    _updateFormData(
        type: TDFormItemType.dateTimePicker, value: newValue); // 添加到 formData
  }

  /// TDCasader 监控数据
  void _localONChange(newValue) {
    print('Local value changed to $newValue');
    _updateFormData(type: TDFormItemType.cascader, value: newValue);
  }

  /// TDStepper 监控数据
  void _stepperONChange(newValue) {
    print('Stepper value changed to $newValue');
    _updateFormData(
        type: TDFormItemType.stepper, value: newValue); // 添加到 formData
  }

  /// TDRate 监控数据
  void _rateONChange(newValue) {
    print('Rate value changed to $newValue');
    _updateFormData(type: TDFormItemType.rate, value: newValue); // 添加到 formData
  }

  @override
  void initState() {
    /// 三个文本型的表格单元
    for (var i = 0; i < 3; i++) {
      _controller.add(TextEditingController());
    }
    super.initState();
  }

  /// 提交按钮钮点击事件：
  /// 改变 _validate 值，从而触发校验
  /// 获取表单的数据
  void _onSubmit() {
    setState(() {
      _validateForm = true;
      for (var i = 0; i < 3; i++) {
        _updateFormData(
            type: TDFormItemType.input,
            num: (i + 1),
            value: _controller[i].text);
      }

      /// 其他通过回调获取数据
      print('Form Data: $_formData');
    });
  }

  /// 定义整个校验规则
  final List<TDFormValidation> _validationRules = [
    TDFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '输入不能为空',
      type: TDFormItemType.input,
    ),
    TDFormValidation(
      validate: (value) =>
          RegExp(r'^[a-zA-Z]{8}$').hasMatch(value ?? '') ? null : 'invalid',
      errorMessage: '只能输入8个字符英文',
      type: TDFormItemType.input,
    ),
    TDFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '输入不能为空',
      type: TDFormItemType.password,
    ),
    TDFormValidation(
      validate: (value) =>
          RegExp(r'^\d+$').hasMatch(value ?? '') ? null : 'invalid',
      errorMessage: '只能输入数字',
      type: TDFormItemType.password,
    ),
    TDFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '输入不能为空',
      type: TDFormItemType.textarea,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'form',
      desc: '基础表单',
      backgroundColor: const Color(0xfff6f6f6),
      children: [
        ExampleModule(title: '基础类型', children: [
          ExampleItem(desc: '基础表单', builder: _buildArrangementSwitch),
          ExampleItem(desc: '', builder: _buildSwitchWithBase),
          ExampleItem(builder: (BuildContext context) {
            return CodeWrapper(builder: _buildForm);
          }),
          ExampleItem(
              ignoreCode: true,
              desc: '',
              builder: (_) => CodeWrapper(builder: _buildCombinationButtons)),
        ]),
      ],
    );
  }

  @Demo(group: 'form')
  Widget _buildForm(BuildContext context) {
    return TDForm(
        disabled: _formDisableState,
        isHorizontal: _isFormHorizontal,
        isValidate: _validateForm,
        rules: _validationRules,
        formContentAlign: TextAlign.left,

        /// 确定整个表单是否展示提示信息
        formShowErrorMessage: true,
        items: [
          TDFormItem(
            label: '用户名',
            type: TDFormItemType.input,
            help: '请输入用户名',
            labelWidth: 43.0,
            controller: _controller[0],

            /// 控制单个 item 是否展示错误提醒
            showErrorMessage: true,
            // requiredMark: true,
          ),
          TDFormItem(
            label: '密码',
            type: TDFormItemType.password,
            help: '请输入密码',
            labelWidth: 60.0,
            controller: _controller[1],
          ),
          TDFormItem(
            label: '性别',
            type: TDFormItemType.radios,
            labelWidth: 50.0,

            /// 扩展一下数量和选项内容
            radios: _radios,
            // radioGroupSpacing: ,
          ),
          TDFormItem(
            label: '生日',
            type: TDFormItemType.dateTimePicker,
            contentAlign: TextAlign.right,

            /// 引入需要的日期数据
            select: _selected_1,
            onChange: _dateONChange,

            ///对于复杂表单项可以自定义传入校验方法
            //itemRule: ,
          ),
          TDFormItem(
            label: '籍贯',
            type: TDFormItemType.cascader,
            contentAlign: TextAlign.right,

            /// 引入需要的地点数据
            localData: _data,
            onChange: _localONChange,

            ///对于复杂表单项可以自定义传入校验方法
            //itemRule: ,
          ),
          TDFormItem(
            label: '年限',
            type: TDFormItemType.stepper,

            /// 为 TDStepper 预留其他设置
            onChange: _stepperONChange,

            ///对于复杂表单项可以自定义传入校验方法
            //itemRule: ,
          ),
          TDFormItem(
            label: '自我评价',
            type: TDFormItemType.rate,
            allowHalf: true,
            rateCount: 5,
            rateValue: 3,
            onChange: _rateONChange,

            ///对于复杂表单项可以自定义传入校验方法
            //itemRule: ,
          ),
          TDFormItem(
            label: '个人简介',
            type: TDFormItemType.textarea,
            help: '请输入个人简介',
            controller: _controller[2],

            /// 为 TDTextarea 长文本其他参数做预留 API
            maxLength: 500,
            indicator: true,
          )
        ]);
  }

  /// 横 竖 排版模式切换按钮
  @Demo(group: 'form')
  Widget _buildArrangementSwitch(BuildContext buildContext) {
    final theme = TDTheme.of(context);
    return Container(
        decoration: BoxDecoration(
          color: theme.whiteColor1,
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TDButton(
                    text: '水平排布',
                    shape: TDButtonShape.round,
                    style:
                        TDButtonStyle(backgroundColor: horizontalButtonColor),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: horizontalTextColor,
                    ),
                    onTap: () {
                      setState(() {
                        if (horizontalButton) {
                          /// 置换按钮状态
                          horizontalButton = false;
                          verticalButton = true;

                          /// 置换按钮颜色
                          final currentVerticalColor = verticalButtonColor;
                          verticalButtonColor = horizontalButtonColor;
                          horizontalButtonColor = currentVerticalColor;

                          /// 置换文字颜色
                          final currentTextColor = verticalTextColor;
                          verticalTextColor = horizontalTextColor;
                          horizontalTextColor = currentTextColor;
                          _isFormHorizontal = true;
                          print(_isFormHorizontal);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TDButton(
                    text: '竖直排布',
                    shape: TDButtonShape.round,
                    style: TDButtonStyle(backgroundColor: verticalButtonColor),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: verticalTextColor,
                    ),
                    onTap: () {
                      setState(() {
                        if (verticalButton) {
                          /// 置换按钮状态
                          horizontalButton = true;
                          verticalButton = false;

                          /// 置换按钮颜色
                          final currentVerticalColor = verticalButtonColor;
                          verticalButtonColor = horizontalButtonColor;
                          horizontalButtonColor = currentVerticalColor;

                          /// 置换文字颜色
                          final currentTextColor = verticalTextColor;
                          verticalTextColor = horizontalTextColor;
                          horizontalTextColor = currentTextColor;

                          _isFormHorizontal = false;
                          print(_isFormHorizontal);
                        }
                      });
                    },
                  ),
                ),
              ],
            )));
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithBase(BuildContext context) {
    return _buildItem(
      context,
      TDSwitch(
        isOn: _formDisableState,
        onChanged: (value) {
          setState(() {
            _formDisableState = value;
          });
          return false;
        },
      ),
      title: '禁用态',
    );
  }

  @Demo(group: 'switch')
  Widget _buildItem(BuildContext context, Widget switchItem,
      {String? title, String? desc}) {
    final theme = TDTheme.of(context);
    Widget current = Row(
      children: [
        Expanded(
            child: TDText(
          title ?? '',
          textColor: theme.fontGyColor1,
        )),
        TDText(
          desc ?? '',
          textColor: theme.grayColor6,
        ),
        SizedBox(child: switchItem)
      ],
    );
    current = Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: SizedBox(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: current,
          ),
          color: Colors.white,
        ),
        height: 56,
      ),
    );
    return Column(mainAxisSize: MainAxisSize.min, children: [current]);
  }

  /// 提交按钮
  @Demo(group: 'button')
  Widget _buildCombinationButtons(BuildContext context) {
    final theme = TDTheme.of(context);
    if (!_formDisableState) {
      return Container(
        decoration: BoxDecoration(
          color: theme.whiteColor1,
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                    child: TDButton(
                  text: '提交',
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  theme: TDButtonTheme.primary,
                  shape: TDButtonShape.rectangle,
                  onTap: _onSubmit,
                )),
              ],
            )),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: theme.whiteColor1,
        ),
        child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                    child: TDButton(
                  text: '提交',
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  theme: TDButtonTheme.primary,
                  shape: TDButtonShape.rectangle,
                  disabled: true,
                )),
              ],
            )),
      );
    }
  }
}
