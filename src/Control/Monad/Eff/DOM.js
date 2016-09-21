"use strict";

exports.querySelectorImpl = function(r, f, s) {
    return function() {
        var result = document.querySelector(s);
        return result ? f(result) : r;
    };
};

exports.addEventListener = function(node) {
    return function(name) {
        return function(handler) {
            return function() {
                node.addEventListener(name, function(e) {
                    handler();
                    e.preventDefault();
                });
            };
        };
    };
};

exports.getBoundingClientRectImpl = function(r, f, n) {
    return function() {
        var result = n.getBoundingClientRect();
        return result ? f(result) : r;
    };
};
