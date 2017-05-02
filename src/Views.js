"use strict";

exports.plotSeries = function(data) {
  return function() {
    MG.data_graphic({
        title: "",
        data: data,
        area: false,
        width: 1000,
        height: 400,
        target: '#tsChart',
        x_accessor: 'date',
        y_accessor: 'value',
        utc_time: true,
        transition_on_update: false
    });      
  }
};

exports.setNodeText = function(id) {
  return function(text) {
    return function() {
      $('#' + id).text(text);
    }
  }
};