module tb_create_component_definition_using_factory();
    
    // drv = ahb_driver::type_id::create("drv", this);

    comp_t = factory.create_component_by_type(ahb_driver::get_type(), "", "drv",this);
    $cast(drv, comp_t);

endmodule
