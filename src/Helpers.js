"use strict";

exports.mkDate = function (t) {
  return new Date(t);
};

exports.toISO = function (d) {
  return d.toISOString();
};