use inc::Module::Install;

name        'Retail';
version     '0.01';
requires
    'Exporter::Lite' => 0,
    'Jifty' => '0.80408',
    'JiftyX::ModelHelpers' => '0.01';

WriteAll;
