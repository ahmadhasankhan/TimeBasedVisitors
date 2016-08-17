
jQuery(function () {
    Morris.Line({
        element: 'visitors_graph',
        data: $('#visitors_graph').data('visitos'),
        xkey: 'event_time',
        ykeys: ['entry', 'exit', 'total'],
        xLabels: 'visitors',
        labels: ['Entry', 'Exit', 'Total'],
        lineColors: ['#167f39', '#990000', '#000099'],
        lineWidth: 2
    });
});