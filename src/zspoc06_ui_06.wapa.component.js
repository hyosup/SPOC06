sap.ui.define(["sap/ui/core/UIComponent","sap/ui/Device","ui5demodeploy/model/models"],function(e,i,t){"use strict";return e.extend("ui5demodeploy.Component",{metadata:{manifest:"json"},init:function(){e.prototype.init.apply(this,arguments);this.getRoute+
r().initialize();this.setModel(t.createDeviceModel(),"device")}})});                                                                                                                                                                                           