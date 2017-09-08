data "template_file" "cloudinit" {
  template = "${file("./cloudinit.tpl")}"
}

resource "cloudca_instance" client-node {
   environment_id = "${var.environment_id}"
   count = "${var.client_count}"
   name="client-${count.index}"
   network_id="0f600937-dd4e-4640-b294-fa527ae369b0"
   template = "Ubuntu 16.04.02 HVM"
   compute_offering = "1vCPU.4GB"
   ssh_key_name = "${var.key_name}"
   user_data = "${data.template_file.cloudinit.rendered}"
}


resource "cloudca_instance" ceph-node {
   environment_id = "${var.environment_id}"
   count = "${var.node_count}"
   name="ceph-${count.index}"
   network_id="0f600937-dd4e-4640-b294-fa527ae369b0"
   template = "Ubuntu 16.04.02 HVM"
   compute_offering = "2vCPU.8GB"
   ssh_key_name = "${var.key_name}"
   user_data = "${data.template_file.cloudinit.rendered}"
}

resource "cloudca_volume" ceph_osd1 {
   environment_id = "${var.environment_id}"
   count = "${var.node_count}"
   disk_offering = "100GB - 100 IOPS Min."
   name = "${element(cloudca_instance.ceph-node.*.name, count.index)}_OSD1"
   instance_id   = "${element(cloudca_instance.ceph-node.*.id, count.index)}"
}

resource "cloudca_volume" ceph_osd2 {
   environment_id = "${var.environment_id}"
   count = "${var.node_count}"
   disk_offering = "100GB - 100 IOPS Min."
   name = "${element(cloudca_instance.ceph-node.*.name, count.index)}_OSD2"
   instance_id   = "${element(cloudca_instance.ceph-node.*.id, count.index)}"
}

resource "cloudca_volume" ceph_osd3 {
   environment_id = "${var.environment_id}"
   count = "${var.node_count}"
   disk_offering = "100GB - 100 IOPS Min."
   name = "${element(cloudca_instance.ceph-node.*.name, count.index)}_OSD3"
   instance_id   = "${element(cloudca_instance.ceph-node.*.id, count.index)}"
}

                                 
