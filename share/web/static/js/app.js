jQuery(function() {

    jQuery(".inline.crud.create.item select.widget.argument-commodity").each(function() {
        new Ext.form.ComboBox({
            transform: this,
            typeAhead: true,
            triggerAction: 'all',
            width:135,
            forceSelection:true
        });
    });

});
