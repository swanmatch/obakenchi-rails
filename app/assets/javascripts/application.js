// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
// require_tree .
//= require jquery
// require jquery_nested_form
//= require select2
//= require select2_locale_ja
// require jquery.remotipart
// require jquery.iframe-transport.js
//= require popper
//= require bootstrap
//= require material
// require bootstrap-datepicker/core
// require bootstrap-datepicker/locales/bootstrap-datepicker.ja
// require bootstrap-timepicker

$(document).on("turbolinks:before-cache", function() {
    $('.select2-input').select2('destroy');
});
$(document).on('turbolinks:load', function () {
  $('.select2').parents('.form-group').removeClass('label-floating');
  $('.select2').select2({
//    theme: "bootstrap"
  });
  $('input.datepicker').pickdate({
    format: 'yyyy/mm/dd',
    labelMonthNext: '翌月',
    labelMonthPrev: '先月',
    labelMonthSelect: '月',
    labelYearSelect: '年',
    monthsLong: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    monthsShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    weekdaysFull: ['日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'],
    weekdaysShort: ['日', '月', '火', '水', '木', '金', '土'],
  });
  $('span.for-datepicker').on('click', function() {
    $(this).prev().focus();
  });

  // Honoka Zone
  var rawData = []; //そのままの値を渡すやつ
  var voltage = []; //電圧を渡すやつ
  var blr_voltage = [];
  var now_voltage = [];
  var temperature = 0;
  var camera = [];
  var camera_flag = [];

  for (var i = 0; i < 3; i++) {
    rawData[i] = document.getElementById("rawData" + i);
    voltage[i] = document.getElementById("voltage" + i);
    camera[i] = document.getElementById("camera" + i);
    blr_voltage[i] = 0;
  }
  console.log("init0:", rawData, voltage);

  main();

  async function main() {
  // Initialize WebI2C
    var i2cAccess = await navigator.requestI2CAccess();
    try {
      //gpio ?????
      var gpioAccess = await navigator.requestGPIOAccess();
      var sensor = document.getElementById("sensor");
      var dPort = gpioAccess.ports.get(5);
      await dPort.export("in");

      //i2c ???????????
      var port = i2cAccess.ports.get(1);
      var ads1115 = new ADS1x15(port, 0x48);
      await ads1115.init(true);
      console.log("new");

      //while (1) {
        try {
        //?????
         dPort.onchange = function(v) {
           if (v === 1) {
            sensor.innerHTML = "ON";
          } else {
            sensor.innerHTML = "OFF";
          }
        };

        for (var i = 0; i < 3; i++) {
          var value = await ads1115.read(i);
          rawData[i].innerHTML = "ch" + i + ":" + value.toString(16);
          if(i == 0){
            voltage[i].innerHTML = (ads1115.getVoltage(value) * -10 + 500).toFixed(4) + "(V * 20)";
            now_voltage[i] = (ads1115.getVoltage(value) * 20);
          } else if(i == 2) {
            voltage[i].innerHTML = (ads1115.getVoltage(value) * -10 + 40).toFixed(4) + "(℃)";
            //now_voltage[i] = (ads1115.getVoltage(value) * 3);
          } else {
            voltage[i].innerHTML = ads1115.getVoltage(value).toFixed(4) + "(V)";
            now_voltage[i] = (ads1115.getVoltage(value));
          }
          /*if( (now_voltage[i] - blf_voltage[i]) > 3 || (now_voltage[i] - blf_voltage[i] < -3) {
            camera_flag[i]++;
          }
          blf_voltage[i] = now_voltage[i];
          camera.HTML[i] = camera_flag[i];*/
        }
      } catch (error) {
        console.log(error);
      }
    //await sleep(2000);
    //}
  } catch (error) {
    console.log("ADS1115.init error" + error);
  }
}
  // Honoka ZoneEnd
});

