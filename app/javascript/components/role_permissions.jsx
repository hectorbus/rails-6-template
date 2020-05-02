import $ from 'jquery';
import React from 'react';
import ReactDOM from 'react-dom';
import { toastr } from 'packs/notifications';
import I18n from 'i18n-js';
I18n.locale = window.I18n.locale;

class RolePermissions extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return this.props.controllers.map((controller) => {
            return (
                <div className="row mb-5" key={controller}>
                    <h5 className="col-12 mb-3">
                        {controller}
                    </h5>
                    {this.props.permissions[controller].map((permission) => {
                        return (
                            <Permission permission={permission} rolePermissionIds={this.props.rolePermissionIds}
                                        roleId={this.props.roleId} key={permission.id}/>
                        )
                    })}
                </div>
            )
        })
    }
}

class Permission extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            checked: this.props.rolePermissionIds.includes(this.props.permission.id),
            loading: false
        };

        this.handleInputChange = this.handleInputChange.bind(this);
    }

    handleInputChange() {
        this.setState({loading: true});
        let authenticityToken = $('[name="csrf-token"]')[0] && $('[name="csrf-token"]')[0].content;
        $.ajax({
            url: '/roles/' + this.props.roleId + '/permission/' + this.props.permission.id,
            data: { authenticity_token: authenticityToken},
            type: 'PUT',
            success: function(data) {
                this.setState({checked: (data.status === 'assigned'), loading: false});
            }.bind(this),
            error: function(err) {
                this.setState({loading: false});
                toastr.warning(I18n.t('messages.try_again'));
            }.bind(this)
        });
    }

    render() {
        return (
            <div className="col-xs-12 col-sm-6 col-md-4 col-lg-3 role-permission-control">
                <div className="control">
                    <span className="m-switch m-switch--outline m-switch--success">
                        <label className="mb-0">
                            <input type="checkbox" checked={this.state.checked} onChange={this.handleInputChange} name="" className='switch-input'/>
                            <span></span>
                        </label>
                    </span>
                </div>
                <div className="title">{this.props.permission.description}</div>
            </div>
        )
    }
}

$(document).on('turbolinks:load', function() {
    let role_permissions = document.getElementById('role_permissions');

    if (role_permissions !== null) {
        let roleId = role_permissions.dataset.roleId;
        let permissions = JSON.parse(role_permissions.dataset.permissions);
        let controllers = Object.keys(permissions);
        let rolePermissionIds = JSON.parse(role_permissions.dataset.rolePermissionIds);
        ReactDOM.render(<RolePermissions roleId={roleId} controllers={controllers} permissions={permissions}
                                         rolePermissionIds={rolePermissionIds}/>, role_permissions)
    }
});
