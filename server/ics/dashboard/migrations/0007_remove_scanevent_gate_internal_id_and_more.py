# Generated by Django 4.2.6 on 2023-11-30 19:01

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('dashboard', '0006_alter_product_weight'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='scanevent',
            name='gate_internal_id',
        ),
        migrations.RemoveField(
            model_name='scanevent',
            name='product_id',
        ),
        migrations.AddField(
            model_name='scanevent',
            name='gate',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='dashboard.rfidgate', verbose_name='Gate that scanned the product'),
        ),
        migrations.AddField(
            model_name='scanevent',
            name='product',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='dashboard.product', verbose_name='Product that was scanned'),
        ),
        migrations.AddField(
            model_name='scanevent',
            name='quantity',
            field=models.PositiveIntegerField(default=0, verbose_name='Quantity of product scanned'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='scanevent',
            name='new_quantity',
            field=models.PositiveIntegerField(verbose_name='New product quantity after scan'),
        ),
    ]
