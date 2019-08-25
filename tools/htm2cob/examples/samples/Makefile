SUBDIRS_SAMPLES = 0001_hello_get            0002_hello_post           0003_hello_form_get \
                  0004_hello_form_post      0005_embedding            0006_comment \
                  0007_variables            0008_copyfile             0009_section \
                  0010_call                 0011_form_elements        0012_env_vars \
                  0013_img_upload           0014_img_upload_scale     0015_multiple_menu \
                  0016_js_alert             0017_more_button          0018_link_submit \
                  0019_menu                 0020_sess_id              0021_sess_var \
                  0022_sess_counter         0023_sess_login           0024_sess_captcha \
                  0025_sess_cart            0026_sess_regen_login     0027_sess_regen_cart \
                  0028_ck_visit             0029_ck_save_data         0030_ck_param \
                  0031_ck_sess_login        0032_ck_sess_captcha      0033_ck_sess_cart \
                  0034_ck_sess_regen_login  0035_ck_sess_regen_cart   0036_ajax_hello \
                  0037_ajax_query_str       0038_jq_form_validate     0039_jq_jcarousel  

.PHONY: all clean $(SUBDIRS_SAMPLES)

default: all

$(SUBDIRS_SAMPLES): 
	$(MAKE) -C $@ $(MAKECMDGOALS) $(SUBFLAGS)

all clean : $(SUBDIRS_SAMPLES)
