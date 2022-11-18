
namespace FIR_GUI
{
    partial class FIR_demo
    {
        /// <summary>
        /// Variable del diseñador necesaria.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpiar los recursos que se estén usando.
        /// </summary>
        /// <param name="disposing">true si los recursos administrados se deben desechar; false en caso contrario.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código generado por el Diseñador de Windows Forms

        /// <summary>
        /// Método necesario para admitir el Diseñador. No se puede modificar
        /// el contenido de este método con el editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FIR_demo));
            this.tableLayoutPanel_fmuestreo = new System.Windows.Forms.TableLayoutPanel();
            this.Fmuestreo_label = new System.Windows.Forms.Label();
            this.tableLayoutPanel4 = new System.Windows.Forms.TableLayoutPanel();
            this.f_muestreo_textbox = new System.Windows.Forms.TextBox();
            this.frec_muestreo_button = new System.Windows.Forms.Button();
            this.tableLayoutPanel_filtro = new System.Windows.Forms.TableLayoutPanel();
            this.Filtro_label = new System.Windows.Forms.Label();
            this.tableLayoutPanel_filtro2 = new System.Windows.Forms.TableLayoutPanel();
            this.Coef_manuales_button = new System.Windows.Forms.Button();
            this.tableLayoutPanel_filtro3 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel_filtro4 = new System.Windows.Forms.TableLayoutPanel();
            this.groupBox_tipo_filtro = new System.Windows.Forms.GroupBox();
            this.button_bypass = new System.Windows.Forms.RadioButton();
            this.button_PA = new System.Windows.Forms.RadioButton();
            this.button_PB = new System.Windows.Forms.RadioButton();
            this.label_tipo_filtro = new System.Windows.Forms.Label();
            this.tableLayoutPanel_filtro5 = new System.Windows.Forms.TableLayoutPanel();
            this.button_frecuencia_corte_down = new System.Windows.Forms.Button();
            this.button_frecuencia_corte_up = new System.Windows.Forms.Button();
            this.label_frec_filtro = new System.Windows.Forms.Label();
            this.label_frecuencia_corte = new System.Windows.Forms.Label();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.finalizar_button = new System.Windows.Forms.Button();
            this.Iniciar_button = new System.Windows.Forms.Button();
            this.refresh_button = new System.Windows.Forms.Button();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.plot_panel = new System.Windows.Forms.Panel();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.checkBox_plot_processed = new System.Windows.Forms.CheckBox();
            this.checkBox_plot_raw = new System.Windows.Forms.CheckBox();
            this.button1 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.tableLayoutPanel_fmuestreo.SuspendLayout();
            this.tableLayoutPanel4.SuspendLayout();
            this.tableLayoutPanel_filtro.SuspendLayout();
            this.tableLayoutPanel_filtro2.SuspendLayout();
            this.tableLayoutPanel_filtro3.SuspendLayout();
            this.tableLayoutPanel_filtro4.SuspendLayout();
            this.groupBox_tipo_filtro.SuspendLayout();
            this.tableLayoutPanel_filtro5.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel_fmuestreo
            // 
            this.tableLayoutPanel_fmuestreo.CellBorderStyle = System.Windows.Forms.TableLayoutPanelCellBorderStyle.Single;
            this.tableLayoutPanel_fmuestreo.ColumnCount = 1;
            this.tableLayoutPanel_fmuestreo.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel_fmuestreo.Controls.Add(this.Fmuestreo_label, 0, 0);
            this.tableLayoutPanel_fmuestreo.Controls.Add(this.tableLayoutPanel4, 0, 1);
            this.tableLayoutPanel_fmuestreo.Location = new System.Drawing.Point(44, 350);
            this.tableLayoutPanel_fmuestreo.Name = "tableLayoutPanel_fmuestreo";
            this.tableLayoutPanel_fmuestreo.RowCount = 2;
            this.tableLayoutPanel_fmuestreo.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 30.43478F));
            this.tableLayoutPanel_fmuestreo.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 69.56522F));
            this.tableLayoutPanel_fmuestreo.Size = new System.Drawing.Size(165, 74);
            this.tableLayoutPanel_fmuestreo.TabIndex = 0;
            // 
            // Fmuestreo_label
            // 
            this.Fmuestreo_label.AutoSize = true;
            this.Fmuestreo_label.Dock = System.Windows.Forms.DockStyle.Fill;
            this.Fmuestreo_label.Location = new System.Drawing.Point(4, 1);
            this.Fmuestreo_label.Name = "Fmuestreo_label";
            this.Fmuestreo_label.Size = new System.Drawing.Size(157, 21);
            this.Fmuestreo_label.TabIndex = 0;
            this.Fmuestreo_label.Text = "Sampling frequency [kHz]";
            this.Fmuestreo_label.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel4
            // 
            this.tableLayoutPanel4.ColumnCount = 2;
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 71.33758F));
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 28.66242F));
            this.tableLayoutPanel4.Controls.Add(this.f_muestreo_textbox, 0, 0);
            this.tableLayoutPanel4.Controls.Add(this.frec_muestreo_button, 1, 0);
            this.tableLayoutPanel4.Location = new System.Drawing.Point(4, 26);
            this.tableLayoutPanel4.Name = "tableLayoutPanel4";
            this.tableLayoutPanel4.RowCount = 1;
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel4.Size = new System.Drawing.Size(157, 44);
            this.tableLayoutPanel4.TabIndex = 1;
            // 
            // f_muestreo_textbox
            // 
            this.f_muestreo_textbox.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.f_muestreo_textbox.Location = new System.Drawing.Point(6, 12);
            this.f_muestreo_textbox.Name = "f_muestreo_textbox";
            this.f_muestreo_textbox.Size = new System.Drawing.Size(100, 20);
            this.f_muestreo_textbox.TabIndex = 1;
            this.f_muestreo_textbox.Text = "1000";
            this.f_muestreo_textbox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // frec_muestreo_button
            // 
            this.frec_muestreo_button.Dock = System.Windows.Forms.DockStyle.Fill;
            this.frec_muestreo_button.Location = new System.Drawing.Point(115, 3);
            this.frec_muestreo_button.Name = "frec_muestreo_button";
            this.frec_muestreo_button.Size = new System.Drawing.Size(39, 38);
            this.frec_muestreo_button.TabIndex = 2;
            this.frec_muestreo_button.Text = "OK";
            this.frec_muestreo_button.UseVisualStyleBackColor = true;
            // 
            // tableLayoutPanel_filtro
            // 
            this.tableLayoutPanel_filtro.CellBorderStyle = System.Windows.Forms.TableLayoutPanelCellBorderStyle.Single;
            this.tableLayoutPanel_filtro.ColumnCount = 1;
            this.tableLayoutPanel_filtro.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel_filtro.Controls.Add(this.Filtro_label, 0, 0);
            this.tableLayoutPanel_filtro.Controls.Add(this.tableLayoutPanel_filtro2, 0, 1);
            this.tableLayoutPanel_filtro.Location = new System.Drawing.Point(44, 70);
            this.tableLayoutPanel_filtro.Name = "tableLayoutPanel_filtro";
            this.tableLayoutPanel_filtro.RowCount = 2;
            this.tableLayoutPanel_filtro.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 9.523809F));
            this.tableLayoutPanel_filtro.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 90.47619F));
            this.tableLayoutPanel_filtro.Size = new System.Drawing.Size(278, 242);
            this.tableLayoutPanel_filtro.TabIndex = 1;
            // 
            // Filtro_label
            // 
            this.Filtro_label.AutoSize = true;
            this.Filtro_label.Dock = System.Windows.Forms.DockStyle.Fill;
            this.Filtro_label.Location = new System.Drawing.Point(4, 1);
            this.Filtro_label.Name = "Filtro_label";
            this.Filtro_label.Size = new System.Drawing.Size(270, 22);
            this.Filtro_label.TabIndex = 0;
            this.Filtro_label.Text = "Filter used";
            this.Filtro_label.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel_filtro2
            // 
            this.tableLayoutPanel_filtro2.ColumnCount = 1;
            this.tableLayoutPanel_filtro2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel_filtro2.Controls.Add(this.Coef_manuales_button, 0, 1);
            this.tableLayoutPanel_filtro2.Controls.Add(this.tableLayoutPanel_filtro3, 0, 0);
            this.tableLayoutPanel_filtro2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel_filtro2.Location = new System.Drawing.Point(4, 27);
            this.tableLayoutPanel_filtro2.Name = "tableLayoutPanel_filtro2";
            this.tableLayoutPanel_filtro2.RowCount = 2;
            this.tableLayoutPanel_filtro2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel_filtro2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 42F));
            this.tableLayoutPanel_filtro2.Size = new System.Drawing.Size(270, 211);
            this.tableLayoutPanel_filtro2.TabIndex = 1;
            // 
            // Coef_manuales_button
            // 
            this.Coef_manuales_button.Dock = System.Windows.Forms.DockStyle.Fill;
            this.Coef_manuales_button.Location = new System.Drawing.Point(3, 172);
            this.Coef_manuales_button.Name = "Coef_manuales_button";
            this.Coef_manuales_button.Size = new System.Drawing.Size(264, 36);
            this.Coef_manuales_button.TabIndex = 0;
            this.Coef_manuales_button.Text = "Enter coefficients manually";
            this.Coef_manuales_button.UseVisualStyleBackColor = true;
            // 
            // tableLayoutPanel_filtro3
            // 
            this.tableLayoutPanel_filtro3.ColumnCount = 2;
            this.tableLayoutPanel_filtro3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel_filtro3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel_filtro3.Controls.Add(this.tableLayoutPanel_filtro4, 0, 0);
            this.tableLayoutPanel_filtro3.Controls.Add(this.tableLayoutPanel_filtro5, 1, 0);
            this.tableLayoutPanel_filtro3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel_filtro3.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel_filtro3.Name = "tableLayoutPanel_filtro3";
            this.tableLayoutPanel_filtro3.RowCount = 1;
            this.tableLayoutPanel_filtro3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel_filtro3.Size = new System.Drawing.Size(264, 163);
            this.tableLayoutPanel_filtro3.TabIndex = 1;
            // 
            // tableLayoutPanel_filtro4
            // 
            this.tableLayoutPanel_filtro4.ColumnCount = 1;
            this.tableLayoutPanel_filtro4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel_filtro4.Controls.Add(this.groupBox_tipo_filtro, 0, 1);
            this.tableLayoutPanel_filtro4.Controls.Add(this.label_tipo_filtro, 0, 0);
            this.tableLayoutPanel_filtro4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel_filtro4.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel_filtro4.Name = "tableLayoutPanel_filtro4";
            this.tableLayoutPanel_filtro4.RowCount = 2;
            this.tableLayoutPanel_filtro4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 25F));
            this.tableLayoutPanel_filtro4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 75F));
            this.tableLayoutPanel_filtro4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel_filtro4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel_filtro4.Size = new System.Drawing.Size(126, 157);
            this.tableLayoutPanel_filtro4.TabIndex = 0;
            // 
            // groupBox_tipo_filtro
            // 
            this.groupBox_tipo_filtro.Controls.Add(this.button_bypass);
            this.groupBox_tipo_filtro.Controls.Add(this.button_PA);
            this.groupBox_tipo_filtro.Controls.Add(this.button_PB);
            this.groupBox_tipo_filtro.Location = new System.Drawing.Point(3, 42);
            this.groupBox_tipo_filtro.Name = "groupBox_tipo_filtro";
            this.groupBox_tipo_filtro.Size = new System.Drawing.Size(120, 100);
            this.groupBox_tipo_filtro.TabIndex = 2;
            this.groupBox_tipo_filtro.TabStop = false;
            // 
            // button_bypass
            // 
            this.button_bypass.AutoSize = true;
            this.button_bypass.Location = new System.Drawing.Point(19, 64);
            this.button_bypass.Name = "button_bypass";
            this.button_bypass.Size = new System.Drawing.Size(81, 17);
            this.button_bypass.TabIndex = 2;
            this.button_bypass.Text = "Bypass filter";
            this.button_bypass.UseVisualStyleBackColor = true;
            // 
            // button_PA
            // 
            this.button_PA.AutoSize = true;
            this.button_PA.Location = new System.Drawing.Point(19, 42);
            this.button_PA.Name = "button_PA";
            this.button_PA.Size = new System.Drawing.Size(95, 17);
            this.button_PA.TabIndex = 1;
            this.button_PA.Text = "High-Pass filter";
            this.button_PA.UseVisualStyleBackColor = true;
            // 
            // button_PB
            // 
            this.button_PB.AutoSize = true;
            this.button_PB.Checked = true;
            this.button_PB.Location = new System.Drawing.Point(19, 19);
            this.button_PB.Name = "button_PB";
            this.button_PB.Size = new System.Drawing.Size(93, 17);
            this.button_PB.TabIndex = 0;
            this.button_PB.TabStop = true;
            this.button_PB.Text = "Low-Pass filter";
            this.button_PB.UseVisualStyleBackColor = true;
            // 
            // label_tipo_filtro
            // 
            this.label_tipo_filtro.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label_tipo_filtro.AutoSize = true;
            this.label_tipo_filtro.Location = new System.Drawing.Point(47, 13);
            this.label_tipo_filtro.Name = "label_tipo_filtro";
            this.label_tipo_filtro.Size = new System.Drawing.Size(31, 13);
            this.label_tipo_filtro.TabIndex = 0;
            this.label_tipo_filtro.Text = "Type";
            // 
            // tableLayoutPanel_filtro5
            // 
            this.tableLayoutPanel_filtro5.ColumnCount = 1;
            this.tableLayoutPanel_filtro5.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel_filtro5.Controls.Add(this.button_frecuencia_corte_down, 0, 3);
            this.tableLayoutPanel_filtro5.Controls.Add(this.button_frecuencia_corte_up, 0, 1);
            this.tableLayoutPanel_filtro5.Controls.Add(this.label_frec_filtro, 0, 0);
            this.tableLayoutPanel_filtro5.Controls.Add(this.label_frecuencia_corte, 0, 2);
            this.tableLayoutPanel_filtro5.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel_filtro5.Location = new System.Drawing.Point(135, 3);
            this.tableLayoutPanel_filtro5.Name = "tableLayoutPanel_filtro5";
            this.tableLayoutPanel_filtro5.RowCount = 4;
            this.tableLayoutPanel_filtro5.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 25F));
            this.tableLayoutPanel_filtro5.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 28.57143F));
            this.tableLayoutPanel_filtro5.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 13.14286F));
            this.tableLayoutPanel_filtro5.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 34.28571F));
            this.tableLayoutPanel_filtro5.Size = new System.Drawing.Size(126, 157);
            this.tableLayoutPanel_filtro5.TabIndex = 1;
            // 
            // button_frecuencia_corte_down
            // 
            this.button_frecuencia_corte_down.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.button_frecuencia_corte_down.BackColor = System.Drawing.Color.Transparent;
            this.button_frecuencia_corte_down.Image = ((System.Drawing.Image)(resources.GetObject("button_frecuencia_corte_down.Image")));
            this.button_frecuencia_corte_down.Location = new System.Drawing.Point(37, 110);
            this.button_frecuencia_corte_down.Name = "button_frecuencia_corte_down";
            this.button_frecuencia_corte_down.Size = new System.Drawing.Size(51, 38);
            this.button_frecuencia_corte_down.TabIndex = 3;
            this.button_frecuencia_corte_down.UseVisualStyleBackColor = false;
            this.button_frecuencia_corte_down.Click += new System.EventHandler(this.button_frecuencia_corte_down_Click);
            // 
            // button_frecuencia_corte_up
            // 
            this.button_frecuencia_corte_up.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.button_frecuencia_corte_up.BackColor = System.Drawing.Color.Transparent;
            this.button_frecuencia_corte_up.Image = ((System.Drawing.Image)(resources.GetObject("button_frecuencia_corte_up.Image")));
            this.button_frecuencia_corte_up.Location = new System.Drawing.Point(35, 41);
            this.button_frecuencia_corte_up.Name = "button_frecuencia_corte_up";
            this.button_frecuencia_corte_up.Size = new System.Drawing.Size(55, 37);
            this.button_frecuencia_corte_up.TabIndex = 2;
            this.button_frecuencia_corte_up.UseVisualStyleBackColor = false;
            this.button_frecuencia_corte_up.Click += new System.EventHandler(this.button_frecuencia_corte_up_Click);
            // 
            // label_frec_filtro
            // 
            this.label_frec_filtro.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label_frec_filtro.AutoSize = true;
            this.label_frec_filtro.Location = new System.Drawing.Point(19, 12);
            this.label_frec_filtro.Name = "label_frec_filtro";
            this.label_frec_filtro.Size = new System.Drawing.Size(88, 13);
            this.label_frec_filtro.TabIndex = 0;
            this.label_frec_filtro.Text = "Cutoff Frequency";
            // 
            // label_frecuencia_corte
            // 
            this.label_frecuencia_corte.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label_frecuencia_corte.AutoSize = true;
            this.label_frecuencia_corte.Location = new System.Drawing.Point(55, 85);
            this.label_frecuencia_corte.Name = "label_frecuencia_corte";
            this.label_frecuencia_corte.Size = new System.Drawing.Size(16, 13);
            this.label_frecuencia_corte.TabIndex = 4;
            this.label_frecuencia_corte.Text = "fc";
            this.label_frecuencia_corte.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 3;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 33.33333F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 33.33333F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 33.33333F));
            this.tableLayoutPanel1.Controls.Add(this.finalizar_button, 2, 0);
            this.tableLayoutPanel1.Controls.Add(this.Iniciar_button, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.refresh_button, 1, 0);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(243, 377);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 1;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(545, 47);
            this.tableLayoutPanel1.TabIndex = 2;
            // 
            // finalizar_button
            // 
            this.finalizar_button.Dock = System.Windows.Forms.DockStyle.Fill;
            this.finalizar_button.Location = new System.Drawing.Point(365, 3);
            this.finalizar_button.Name = "finalizar_button";
            this.finalizar_button.Size = new System.Drawing.Size(177, 41);
            this.finalizar_button.TabIndex = 3;
            this.finalizar_button.Text = "Stop";
            this.finalizar_button.UseVisualStyleBackColor = true;
            this.finalizar_button.Click += new System.EventHandler(this.finalizar_button_Click);
            // 
            // Iniciar_button
            // 
            this.Iniciar_button.Dock = System.Windows.Forms.DockStyle.Fill;
            this.Iniciar_button.Location = new System.Drawing.Point(3, 3);
            this.Iniciar_button.Name = "Iniciar_button";
            this.Iniciar_button.Size = new System.Drawing.Size(175, 41);
            this.Iniciar_button.TabIndex = 0;
            this.Iniciar_button.Text = "Start";
            this.Iniciar_button.UseVisualStyleBackColor = true;
            this.Iniciar_button.Click += new System.EventHandler(this.Iniciar_button_Click);
            // 
            // refresh_button
            // 
            this.refresh_button.Dock = System.Windows.Forms.DockStyle.Fill;
            this.refresh_button.Location = new System.Drawing.Point(184, 3);
            this.refresh_button.Name = "refresh_button";
            this.refresh_button.Size = new System.Drawing.Size(175, 41);
            this.refresh_button.TabIndex = 1;
            this.refresh_button.Text = "Refresh";
            this.refresh_button.UseVisualStyleBackColor = true;
            this.refresh_button.Click += new System.EventHandler(this.refresh_button_Click);
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.CellBorderStyle = System.Windows.Forms.TableLayoutPanelCellBorderStyle.Single;
            this.tableLayoutPanel2.ColumnCount = 1;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel2.Controls.Add(this.plot_panel, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.tableLayoutPanel3, 0, 1);
            this.tableLayoutPanel2.Location = new System.Drawing.Point(362, 70);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 2;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 90F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 10F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(403, 297);
            this.tableLayoutPanel2.TabIndex = 3;
            // 
            // plot_panel
            // 
            this.plot_panel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.plot_panel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.plot_panel.Location = new System.Drawing.Point(4, 4);
            this.plot_panel.Name = "plot_panel";
            this.plot_panel.Size = new System.Drawing.Size(395, 258);
            this.plot_panel.TabIndex = 0;
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 2;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel3.Controls.Add(this.checkBox_plot_processed, 1, 0);
            this.tableLayoutPanel3.Controls.Add(this.checkBox_plot_raw, 0, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(4, 269);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(395, 24);
            this.tableLayoutPanel3.TabIndex = 1;
            // 
            // checkBox_plot_processed
            // 
            this.checkBox_plot_processed.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.checkBox_plot_processed.AutoSize = true;
            this.checkBox_plot_processed.Location = new System.Drawing.Point(243, 3);
            this.checkBox_plot_processed.Name = "checkBox_plot_processed";
            this.checkBox_plot_processed.Size = new System.Drawing.Size(106, 17);
            this.checkBox_plot_processed.TabIndex = 1;
            this.checkBox_plot_processed.Text = "Processed signal";
            this.checkBox_plot_processed.UseVisualStyleBackColor = true;
            // 
            // checkBox_plot_raw
            // 
            this.checkBox_plot_raw.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.checkBox_plot_raw.AutoSize = true;
            this.checkBox_plot_raw.Location = new System.Drawing.Point(59, 3);
            this.checkBox_plot_raw.Name = "checkBox_plot_raw";
            this.checkBox_plot_raw.Size = new System.Drawing.Size(78, 17);
            this.checkBox_plot_raw.TabIndex = 0;
            this.checkBox_plot_raw.Text = "Raw signal";
            this.checkBox_plot_raw.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(568, 178);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 2;
            this.button1.Text = "button1";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(282, 19);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(266, 37);
            this.label1.TabIndex = 4;
            this.label1.Text = "FIR Filter DEMO";
            // 
            // FIR_demo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.tableLayoutPanel2);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Controls.Add(this.tableLayoutPanel_filtro);
            this.Controls.Add(this.tableLayoutPanel_fmuestreo);
            this.Name = "FIR_demo";
            this.Text = "FIR Filter Demo";
            this.tableLayoutPanel_fmuestreo.ResumeLayout(false);
            this.tableLayoutPanel_fmuestreo.PerformLayout();
            this.tableLayoutPanel4.ResumeLayout(false);
            this.tableLayoutPanel4.PerformLayout();
            this.tableLayoutPanel_filtro.ResumeLayout(false);
            this.tableLayoutPanel_filtro.PerformLayout();
            this.tableLayoutPanel_filtro2.ResumeLayout(false);
            this.tableLayoutPanel_filtro3.ResumeLayout(false);
            this.tableLayoutPanel_filtro4.ResumeLayout(false);
            this.tableLayoutPanel_filtro4.PerformLayout();
            this.groupBox_tipo_filtro.ResumeLayout(false);
            this.groupBox_tipo_filtro.PerformLayout();
            this.tableLayoutPanel_filtro5.ResumeLayout(false);
            this.tableLayoutPanel_filtro5.PerformLayout();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel_fmuestreo;
        private System.Windows.Forms.Label Fmuestreo_label;
        private System.Windows.Forms.TextBox f_muestreo_textbox;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel_filtro;
        private System.Windows.Forms.Label Filtro_label;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel_filtro2;
        private System.Windows.Forms.Button Coef_manuales_button;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel_filtro3;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel_filtro4;
        private System.Windows.Forms.Label label_tipo_filtro;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel_filtro5;
        private System.Windows.Forms.Label label_frec_filtro;
        private System.Windows.Forms.GroupBox groupBox_tipo_filtro;
        private System.Windows.Forms.Button button_frecuencia_corte_down;
        private System.Windows.Forms.Button button_frecuencia_corte_up;
        private System.Windows.Forms.Label label_frecuencia_corte;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.Button Iniciar_button;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.Panel plot_panel;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.CheckBox checkBox_plot_processed;
        private System.Windows.Forms.CheckBox checkBox_plot_raw;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.RadioButton button_bypass;
        private System.Windows.Forms.RadioButton button_PA;
        private System.Windows.Forms.RadioButton button_PB;
        private System.Windows.Forms.Button finalizar_button;
        private System.Windows.Forms.Button refresh_button;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel4;
        private System.Windows.Forms.Button frec_muestreo_button;
    }
}

