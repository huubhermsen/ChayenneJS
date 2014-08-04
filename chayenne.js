var Chayenne;

Chayenne = (function() {
  var elements, listElements;

  elements = [];

  Chayenne.prototype.elements = [];

  function Chayenne() {
    listElements();
  }

  listElements = function() {
    return console.log(Chayenne.prototype.elements);
  };

  return Chayenne;

})();
