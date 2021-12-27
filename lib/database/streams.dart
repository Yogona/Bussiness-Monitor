import 'dart:async';

StreamController<List> userCounterStream  = StreamController<List>.broadcast();
StreamController<List> productsStream     = StreamController<List>.broadcast();
StreamController<List> purchasesStream    = StreamController<List>.broadcast();
StreamController<List> salesStream        = StreamController<List>.broadcast();
StreamController<List> invoicesStream     = StreamController<List>.broadcast();