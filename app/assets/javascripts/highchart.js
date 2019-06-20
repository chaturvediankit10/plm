$(document).ready(function(){
	$(function () {
    var chart = new Highcharts.Chart({
        title: {
          verticalAlign: 'middle',
          floating: true,
          text: '' + monthly_expenses_sum + '' + '<br /> Monthly Payment',
          floating: false,
          align: 'center',
          style: {
            fontFamily: 'dinotmedium',
          }
        },
        chart: {
          renderTo: 'container-a',
          type: 'pie'
        },
        colors: ['#687b82', '#83b2c2', '#3b86b6', '#592c67', '#7f8930'],
        plotOptions: {
          pie: {
            innerSize: '70%'
          },
          series: {
            dataLabels: {
              enabled: true,
              borderRadius: 0,
              backgroundColor: '#fff',
              borderWidth: 2,
              borderColor: '#ccc',
              boxShadow: '5px 5px 5px #ccc',
              formatter: function () {
                if (this.y != 0) {
                  return ('<span class="labels-name">'+this.point.name +'</span><br/><span class="value-lable"> $'+ Math.round(this.point.y) +'</span><br/><span >'+ (Math.round(this.percentage)) + '%</span>');
                }
                // return ('<div><p>'+this.point.name+'</p><span>'+this.point.y+'</span></div>');
              },
            },
          }
        },
        series: [{
          data: [
            ["Home Insurance", monthly_home_insurance],
            ["Property Tax", monthly_property_tax],
            ["PMI Insurance", monthly_pmi_insurance],
            ["HOA Dues", monthly_hoa_dues],
            ["Principal & Interest", (monthly_mortgage_principal + monthly_mortgage_interest)]
          ],
        }, ],
      },

    function (chart) { // on complete

      // var textX = chart.plotLeft + (chart.plotWidth  * 0.5);
      // var textY = chart.plotTop  + (chart.plotHeight * 0.5);
      // var span = '<span id="pieChartInfoText" style="position:absolute; text-align:center;">';
      // span += '<b><span>'+'$' + Number((monthly_expenses_sum).toFixed(2)) +'</span><br>';
      // span += '<span class="m-payment">Monthly Payment</span></b>';
      // span += '</span>';

      // $("#addText").append(span);
      // span = $('#pieChartInfoText');
      // span.css('left', textX + (span.width() * -0.5));
      // span.css('top', textY + (span.height() * -0.5));
    });
 	});
});
