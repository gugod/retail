jQuery(function() {

    jQuery(".inline.crud.create.item select.widget.argument-commodity").each(function() {
        new Ext.form.ComboBox({
            mode: 'local',
            transform: this,
            selectOnFocus: true
        });
    });

});
