class SetupOVSException(Exception):
    """
    Base class for exception in setup_ovs module
    """


class SetupOVSConfigException(SetupOVSException):
    """
    JSON configuration exception class
    """
