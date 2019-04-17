function js_exchangeImplementation(){
    var swizzleList = new Array();

    var exchangeObj1 = {oc_class:'MultiChannelDemoViewController', oc_method:'test:'}
    swizzleList.push(exchangeObj1);
    for(var i = 0; i < swizzleList.length; ++ i){
        var obj = swizzleList[i];
        exchangeImplementation(obj.oc_class, obj.oc_method, 'v_method_block:');
    }
}
js_exchangeImplementation();
