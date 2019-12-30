function main_exchangeImplementation(){
    var swizzleList = new Array();

    var exchangeObj1 = {oc_class:'MultiChannelDemoViewController', oc_method:'test:'}
    swizzleList.push(exchangeObj1);
    for(var i = 0; i < swizzleList.length; ++ i){
        var obj = swizzleList[i];
        js_exchangeImplementation(obj.oc_class, obj.oc_method);
    }
}
main_exchangeImplementation();
