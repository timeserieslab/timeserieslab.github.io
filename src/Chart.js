"use strict";

exports.plotSeries = function(data) {
  MG.data_graphic({
      title: "",
      data: data,
      area: false,
      width: 1000,
      height: 400,
      target: '#tsChart',
      x_accessor: 'date',
      y_accessor: 'value'
  });      
};